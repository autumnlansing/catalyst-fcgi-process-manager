#!/usr/bin/perl

use strict;
use warnings;

my ($kbytes) = @ARGV;

die "Usage: fcgi_manager ram_limit_in_kilobytes\n" unless $kbytes;

my @pids = `pgrep -x perl-fcgi` or die 'No fcgi processes running';
my $mem;

foreach my $pid (@pids) {
    $mem = `/bin/ps -o vsz= --pid $pid`;

    if ( $mem >= $kbytes ) {
        kill 'HUP', $pid or die 'Unable to kill process';

        # Give the process time to die before killing another one.
        sleep 10;
    }
}
