use strict;
use warnings;
use Test::More;

use AnyEvent;
use Log::Stash::Input::ZeroMQ;
use Log::Stash::Output::Test;
use Log::Stash::Output::ZeroMQ;

my $output = Log::Stash::Output::ZeroMQ->new();

$output->consume({foo => 'bar'});

use Log::Stash::Input::ZeroMQ;
use Log::Stash::Output::Test;
my $cv = AnyEvent->condvar;
my $input = Log::Stash::Input::ZeroMQ->new(
    output_to => Log::Stash::Output::Test->new(
        on_consume_cb => sub { $cv->send }
    ),
);
$cv->recv;

is $input->output_to->message_count, 1;
is_deeply([$input->output_to->messages], [{foo => 'bar'}]);

done_testing;
