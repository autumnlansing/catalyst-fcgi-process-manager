#!/usr/bin/perl

use strict;
use warnings;

=head1 NAME

Catalyst FCGI Process Monitor

=head1 VERSION

version 1.0

=head1 SYNOPSIS

Supply an argument for the maximum size of memory in kilobytes allowed each
child process.

    fcgi_manager.pl 300000

=head1 DESCRIPTION

Child processes created by a daemonized Catalyst myapp_fastcgi.pl script can
sometimes grow significantly in memory size, causing the need to kill them
from time to time or face server slowdown. Some of this may be due to memory
leaks in your app, though some of it could be due to general copy-on-write
behavior. To fix the latter, or to stave off fixing the former if you don't
currently have time for the minutae of leak tracing, this script monitors
fastcgi child processes and gracefully kills those who grow beyond a set size.

=cut

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

=head1 AUTHOR

Autumn Lansing

=head1 COPYRIGHT AND LICENSE

This script is copyright (c) 2015 by Autumn Lansing.

This is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
