Catalyst FCGI Process Manager
=============================

Child processes created by a daemonized Catalyst `myapp_fastcgi.pl` script can sometimes grow significantly in memory size, causing the need to kill them from time to time or face server slowdown. Some of this may be due to memory leaks in your app, though some of it could be due to general copy-on-write behavior. To fix the latter, or to stave off fixing the former if you don't currently have time for the minutae of leak tracing, this script monitors fastcgi child processes and gracefully kills those who grow beyond a set size.

Usage
-----

To use, call with the maximum memory limit you will allow each child process, in kilobytes:

`fcgi_manager.pl 300000`

To automate this, simply set it up as a cron job.

Inspiration
-----------

This script was inspired by the posting at http://www.catalystframework.org/calendar/2007/18 but slimmed down considerably in the following ways:

* No need to feed the parent process' pid file to the script and use that for finding the child processes. Each child process is named `perl-fcgi`. Simply search for them directly with `pgrep` to get their pids.
* No need to loop through all the child processes to find which are above the memory limit, put them into a new array, and then kill them, Simply kill them as you find them.
* No need to convert kilobytes to bytes. `ps` reports in kilobytes, so just use kilobytes by default.

License
-------

This script is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
