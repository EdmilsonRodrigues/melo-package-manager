use v5.42;
use feature 'class';
use utf8;                        
use open qw(:std :encoding(UTF-8));
use lib 'lib';

use List::Util qw(any);

use Melo::CLI::Parser::Help;
use Melo::CLI::Parser::Build;
use Melo::CLI::Parser::Package;

use Melo::Utils::Logger;

class Melo::CLI::Parser {
  field $raw_args :param = [];

  field $_arguments = [];
  field $_flags = [];
  field $logger;

  field $parsed_data = {};

  field %application_dispatcher;

  field %global_flags = (
    '--help'    => 'help',
    '-h'        => 'help',
    '--quiet'   => 'quiet',
    '-q'        => 'quiet',
    '--verbose' => 'verbose',
    '-v'        => 'verbose',
    '--debug'   => 'debug',
    '-d'        => 'debug',
    );

  ADJUST {
    %application_dispatcher = (
      'help'    => sub { $self->_parse_help_commands() },
      'package' => sub { $self->_parse_package_commands() },
      'build'   => sub { $self->_parse_build_commands() },
      );
  }

  method parse_args() {
    $self->_get_options();
    $self->_parse_global_flags();
    $self->_build_logger();

    my $cmd = $_arguments->[0];
    unless (defined $cmd) {
      $self->show_help([], 1);
    }

    $self->_parse_application($cmd);

    return $parsed_data;
  }

  method show_help($commands_ref = [], $is_error = 0) {
    my $help = Melo::CLI::Parser::Help->new(
                 commands => $commands_ref,
                 logger   => $logger,
      );

    my $help_error = $help->show();
    $is_error ||= $help_error;

    exit $is_error;
  }

  method _parse_global_flags() {
    for my $arg (@$_flags) {
      if (exists $global_flags{$arg}) {
        my $flag_name = $global_flags{$arg};
        $parsed_data->{$flag_name} = 1;
      }
    }
  }

  method _get_options() {
    for my $arg (@$raw_args) {
      if ($arg =~ /\A-/) {
        push @$_flags, $arg;
      } else {
        push @$_arguments, $arg;
      }
    }
  }

  method _build_logger() {
    my $level = 'info';
    if ($parsed_data->{'quiet'}) {
      $level = 'quiet';
    } elsif ($parsed_data->{'debug'}) {
      $level = 'debug';
    } elsif ($parsed_data->{'verbose'}) {
      $level = 'verbose';
    }

    $logger = Melo::Utils::Logger->new(level => $level);
  }

  method _parse_application($cmd) {
    my $application = $application_dispatcher{$cmd};
    unless (defined $application) {
      $self->show_help([], 1);
    }
    $application->();
  }

  method _parse_help_commands() {
    my @sub_commands = splice(@$_arguments, 1);
    $self->show_help(\@sub_commands, 0);
  }

  method _parse_package_commands() {
    $parsed_data->{mode} = 'package';
    $self->_parse_commands('Melo::CLI::Parser::Package');
  }

  method _parse_build_commands() {
    $parsed_data->{mode} = 'build';
    $self->_parse_commands('Melo::CLI::Parser::Build');
  }

  method _parse_commands($class_name) {
    $self->_call_help_if_needed();

    shift @$_arguments;

    my $parser = $class_name->new(
                   raw_arguments=>$_arguments,
                   raw_flags=>$_flags,
                   logger=>$logger,
      );

    $parsed_data->{application} = $parser->parse();
  }

  method _call_help_if_needed() {
    if ($parsed_data->{'help'}) {
      unshift(@$_arguments, 'help');
      $self->_parse_help_commands();
    }
  }
}

1;
