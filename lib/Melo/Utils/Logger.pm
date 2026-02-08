use v5.42;
use feature 'class';
use utf8;                        
use open qw(:std :encoding(UTF-8));

class Melo::Utils::Logger {
    field $level :param = 'info';

    method log($message_level, $message) {
        state $priorities = {quiet => 0, info => 1, verbose => 2, debug => 3};

        return if $priorities->{$msg_level} > $priorities->{$level};

        my $timestamp = localtime;
        say "[$timestamp] [$msg_level] $message";
    }

    method info($msg)    { $self->log('info',  $msg)   }
    method debug($msg)   { $self->log('debug', $msg)   }
    method verbose($msg) { $self->log('verbose', $msg) }
    
    method error($msg)   {
        warn "[ERROR] $msg\n"
    }
}
