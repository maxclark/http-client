#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;
use Getopt::Std;

my %opts;
getopts('d:h', \%opts);

my $usage = "$0: host port < httpreq\n";
my $host = shift || die $usage;
my $port = shift || die $usage;

my $sock = IO::Socket::INET->new(PeerAddr => $host, PeerPort => $port);
die "$host:$port: $!" unless $sock;

while (<>) {
	$sock->print($_);
	select(undef, undef, undef, $opts{d}) if $opts{d};
}

while (defined($_ = $sock->getline)) {
	print $_;
	last if ($opts{h} && /^\s*$/);
}
1 while ($opts{h} && defined($sock->getline));
$sock->close;
