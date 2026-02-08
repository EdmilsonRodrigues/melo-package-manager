use v5.42;
use feature 'class';
use utf8;                        # Source code is UTF-8
use open qw(:std :encoding(UTF-8)); # I/O is UTF-8
use lib 'lib';
use Melo::CLI::Parser;

my $parser = Melo::CLI::Parser->new(raw_args => \@ARGV);
my $data = $parser->parse_args();
say $data;


