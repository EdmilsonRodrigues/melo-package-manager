use v5.42;
use feature 'class';
use utf8;                        
use open qw(:std :encoding(UTF-8));

class Melo::CLI::HelpBuilder {
  field $usage        :param;
  field $description  :param;
  field $applications :param = {};
  field $commands     :param = {};
  field $arguments    :param = {};
  field $flags        :param = {};

  method generate() {
    my $output =<<~EOF;
    Melo Package Manager (AGPL) - Edmilson Rodrigues\@2026

    Usage: $usage

    $description


    EOF

    if (keys %$applications) {
      $output .= $self->_fill_help_block("APPLICATIONS", $applications);
    }

    if (keys %$commands) {
      $output .= $self->_fill_help_block("COMMANDS", $commands);
    }

    if (keys %$arguments) {
      $output .= $self->_fill_help_block("ARGUMENTS", $arguments);
    }

    if (keys %$flags) {
      $output .= $self->_fill_help_block("FLAGS", $flags);
    }

    return $output;
  }

  method _fill_help_block($text, $map) {
    my $output = $text . ":\n";
    for my $key (sort keys %$map) {
      $output .= $self->_get_map_line $key, $map;
    }
    $output .= "\n";
    return $output;
  }

  method _get_map_line($key, $map) {
    return sprintf("  %-15s %s\n", $key, $map->{$key});
  }
}

1;
