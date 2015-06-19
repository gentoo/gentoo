#!/usr/bin/perl
#
#   $Id: pptp_fe.pl,v 1.1 2003/02/26 23:31:46 agriffis Exp $
#
#   pptp_fe.pl, privileged portion of xpptp_fe.pl
#   Copyright (C) 2001  Smoot Carl-Mitchell (smoot@tic.com)
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

use strict;
use Getopt::Std;
use Time::localtime;
use IO::Handle;

my $Usage = "usage: pptp_fe [-c config_file] [-d] [-h] [-k] [-n network]
		[-p] [-r routes] [-t timeout] [host]
	where:
	-c - configuration file (default is ~/.pptp_fe.conf)
	-d - pppd debug flag
	-h - this help message
	-k - kill pppd daemon with route to network
	-n - network number of remote private network in x.x.x.x/n notation
	-r - routes to add to routing table separated by commas
	-p - suppress prompting
	-t - connection timeout retry interval in seconds (default 60 seconds)
	host - remote PPTP server name
";

my %Opt;
getopts("c:dhkn:pr:t:", \%Opt);

my $Config_File = $Opt{'c'};
$Config_File = "$ENV{'HOME'}/.pptp_fe.conf" unless $Opt{'c'};
my $Config;
my $Debug = $Opt{'d'};
$Debug = 0 unless $Debug;
my $Debug_Flag = "debug" if $Debug;
my $Help = $Opt{'h'};
my $Kill = $Opt{'k'};
my $Net = $Opt{'n'};
my $No_Prompt = $Opt{'p'};
my $Route = $Opt{'r'};
my $Timeout = $Opt{'t'}; $Timeout = 60 unless $Timeout;

print($Usage), exit(1) if $Help; 

my $Server = $ARGV[0];

my $State = "disconnected";

system("modprobe ppp-compress-18");

$Config = cmd_read_config_file($Config_File);
for my $cmd (@$Config) {
	cmd_set($cmd, 1);
}

print "($State) > " unless $No_Prompt;
STDOUT->flush;
for (;;) {
	my $rin = '';
	my $rout = '';
	vec($rin, fileno(STDIN), 1) = 1;
	command() if select($rout=$rin,  undef, undef, 5);

	my $interface = "";
	if ($State eq "connected" && ! ($interface = net_interface_up($Net))) {
		print "\n";
		print "interface $interface for $Net not up - restarting\n";
		cmd_connect();
		print "($State) > " unless $No_Prompt;;
	}
}

sub command {

	my $input;
	sysread(STDIN, $input, 1024);

	for my $line1 (split("\n", $input)) {
		my $line = $line1;
		$line =~ s/\s*$//;
		$line =~ s/^\s*//;
		my ($command, $arguments) = split(" ", $line, 2);

		if ($command eq "c") {
			cmd_connect();
		}
		elsif ($command eq "d") {
			cmd_disconnect();
		}
		elsif ($command eq "h") {
			cmd_help();
		}
		elsif ($command eq "l") {
			cmd_list();
		}
		elsif ($command eq "q") {
			cmd_disconnect();
			exit 0;
		}
		elsif ($command eq "r") {
			$Config = cmd_read_config_file($arguments);
		}
		elsif ($command eq "s") {
			cmd_set($arguments, 0);
		}
		elsif ($command eq "w") {
			cmd_write_config_file($arguments);
		}
		elsif ($command ne "") {
			print "unknown command\n";
		}
	}
	print "($State) > " unless $No_Prompt;
	STDOUT->flush;
}

sub cmd_connect {

	cmd_disconnect() if $State eq "connected";

	my $start_time = time();
	my $date_string = ctime($start_time);
	print "$date_string Running pptp $Server $Debug_Flag";
	system("pptp $Server $Debug_Flag");
	
	my $interface = "";
	
	do {
		sleep 1;
		$interface = net_interface_up($Net);
		print ".";
	} until ($interface || time() > $start_time + $Timeout);
	
	if (time() > $start_time + $Timeout) {
		print "timed out after $Timeout sec\n";
		$State = "disconnected";
		return 0;
	}

	print "\n";
	
	my $ifcfg = `ifconfig $interface`;
	$ifcfg =~ /P-t-P:(.*)  Mask/;
	my $ip = $1;
	print "setting route to network $Net to interface $interface\n";
	system("route add -net $Net dev $interface metric 2");
	
	# Routes are separated by commas
	my @route = split(/,/, $Route);
	for my $route (@route) {
		my $net_flag = "";
		$net_flag = "-net" if $route =~ /\//;
	
		print "setting route to $route to interface $interface\n";
		system("route add $net_flag $route dev $interface");
	}

	$State = "connected";
	print "connected\n";
	return 1;
}

sub cmd_disconnect {

	return 1 if $State eq "disconnected";

	my $interface = net_interface_up($Net);
	my $pid_file = "/var/run/$interface.pid";

	# delete the named pipes - XXX this is a bit crude
	system("rm -f /var/run/pptp/*");
	
	$State = "disconnected", return 1 unless $interface && -f $pid_file;

	my $pid = `cat $pid_file`; 
	chomp $pid;
	print "killing pppd($pid)\n";
	kill("HUP", $pid);
	print "waiting for pppd to die";
	do {
		sleep 1;
		print ".";
	}
	until (kill(0, $pid));

	print "\n";
	$State = "disconnected";
	print "disconnected\n";
	return 1;
}

sub cmd_list {

	print "Server = $Server\n";
	print "Network = $Net\n";
	print "Routes = $Route\n";
	print "Debug = $Debug_Flag\n";
	print "No_Prompt = $No_Prompt\n";
	print "Timeout = $Timeout\n";
	print "\n";
}

sub cmd_help {

	print "Commands are:\n";
	print "c - initiate PPTP connection\n";
	print "d - disconnect PPTP\n";
	print "h - this help message\n";
	print "l - list current configuration\n";
	print "q - quite the program\n";
	print "r - read configuration file\n";
	print "s - set configuration variable (l for a list)\n";
	print "w - write the configuration file\n";

}

sub cmd_set {
	my $input = shift;
	my $no_replace = shift;

	my ($variable, $value) = split(/\s*=\s*/, $input);

	$variable = "\L$variable";
	if (! $variable) {
		print "syntax: s variable = value\n";
		return 0;
	}

	if ($variable eq "server") {
		$Server = $value unless $no_replace && $Server;
	}
	elsif ($variable eq "network") {
		$Net = $value unless $no_replace && $Net;
	}
	elsif ($variable eq "routes") {
		$Route = $value unless $no_replace && $Route;
	}
	elsif ($variable eq "debug") {
		$Debug_Flag = $value unless $no_replace && $Debug_Flag;
	}
	elsif ($variable eq "no_prompt") {
		$No_Prompt = $value unless $no_replace && $No_Prompt;
	}
	elsif ($variable eq "timeout") {
		$Timeout = $value unless $no_replace && $Timeout;
	}
	elsif ($variable eq "config_file") {
		$Config_File = $value unless $no_replace && $Config_File;
	}
	else {
		print "unknown variable\n";
	}
}

sub cmd_read_config_file {
	my $file = shift;

	my $config = [];
	$file = $Config_File unless $file; 
	local *IN;
	if (!open(IN, $file)) {
		print "cannot open $file\n";
		return $config;
	}

	my @config_file = <IN>;
	close IN;
	push @config_file, "\n";
	chomp @config_file;

	for my $line (@config_file) {
		next if /\s*#/;

		if ($line =~ /\S/) {
			$line =~ s/^\s*//;
			$line =~ s/\s*$//;
			push @$config, $line;
			next;
		}
	}
	return $config;
}

sub cmd_write_config_file {
	my $file = shift;

	$file = $Config_File unless $file; 
	local *OUT;
	if (!open(OUT, ">$file")) {
		print "cannot open $file\n";
		return 0;
	}

	my $oldfh = select OUT;
	cmd_list();
	close OUT;
	select $oldfh;

	return 1;
}

sub net_interface_up {
	my $cidr = shift;

	# cidr is net/bits
	my($net, $nbits) = split(/\//, $cidr);

	# compute the network number
	my $netnum = netnum($net, $nbits);
	local(*INTERFACE);
	open(INTERFACE, "ifconfig|") || die "cannot run ifconfig - $!\n";

	my $interface = "";
	my @interface = <INTERFACE>;
	close INTERFACE;
	for  (@interface) {
		chomp;

		# new interface
		if (/^[a-zA-Z]/) {
			if ($interface =~ /(.*)      Link.*P-t-P:(.*)  Mask/) {
				my $interface_name = $1;
				my $ip = $2;
				return $interface_name
					if netnum($ip, $nbits) == $netnum;
			}
			$interface = "";
		}
		$interface .= $_;
	}
	return "";
}

sub netnum {
	my $net = shift;
	my $bits = shift;

	my @octets = split(/\./, $net);
	my $netnum = 0;
	for my $octet (@octets) {
		$netnum <<= 8;
		$netnum |= $octet;
	}

	my $mask = 0;
	for (1..$bits) {
		$mask <<= 1;
		$mask |= 1;
	}
	$mask = $mask << (32-$bits);

	$netnum &= $mask;

	return $netnum;
}
