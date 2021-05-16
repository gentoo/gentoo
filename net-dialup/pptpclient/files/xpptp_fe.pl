#!/usr/bin/perl -w
#
#   $Id: xpptp_fe.pl.pl,v 1.1 2001/11/29 05:19:10 quozl Exp $
#
#   xpptp_fe.pl.pl, graphical user interface for PPTP configuration
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

use Tk;
use Tk::DirTree;

=pod
TK driver for pptp_fe.pl command script
=cut

=pod
Global flags which correspnd to the pptp_fe.pl flags and options
=cut

my $Debug = 0;
my $Debug_Flag = "";
my $Network = "";
my $Server = "";
my $Routes = "";
my $Get_Current_Config = 0;

=pod

Start up pptp_fe.pl and connect its input and output to the TK frontend.
All I/O is done in raw mode, so the reads and writes are atomic and
unbuffered.

=cut

pipe OUTPUT_READ, OUTPUT_WRITE;
pipe COMMAND_READ, COMMAND_WRITE;

my $Child_Pid = fork();
die "cannot fork - $!\n" if $Child_Pid == -1;

if ($Child_Pid) { # parent
	close OUTPUT_WRITE;
	close COMMAND_READ;
}
else { # child
	close OUTPUT_READ;
	close COMMAND_WRITE;

	open(STDIN, "<&COMMAND_READ");
	open(STDOUT, ">&OUTPUT_WRITE");
	
	exec("pptp_fe.pl -p");
}

=pod
The main window which present the various pptp_fe.pl options.

The window is composed of:

		Server name
		Network number
		Routes
Connect Button Disconnect Button Write Config Button Quit Button
=cut

my $Main = MainWindow->new();
$Main->Label(-text => "PPTP")->pack;

my $Server_Frame = $Main->Frame->pack(-fill => 'x',
	-padx => 5,
	-pady => 5);

$Server_Frame->Label(-text => "Remote PPTP Host")->pack(-side => "left");
$Server_Frame->Entry(
	-text => "Host",
	-width => 30,
	-textvariable => \$Server,
	)->pack(-side => "left");


my $Net_Frame = $Main->Frame->pack(-fill => 'x',
	-padx => 5,
	-pady => 5);

=pod
Network number entry box.  This is the argument to the the -n flag
=cut

$Net_Frame->Label(-text => "Network Number")->pack(-side => "left");
$Net_Frame->Entry(
	-text => "Network",
	-width => 15,
	-textvariable => \$Network,
	)->pack(-side => "left");

=pod
Additional static routes (-r) flag
=cut

my $Route_Frame = $Main->Frame->pack(
	-fill => 'x',
	-padx => 5,
	-pady => 5);

$Route_Frame->Label(-text => "Routes")->pack(-side => "left");

$Route_Frame->Entry(
	-text => "Routes",
	-width => 30,
	-textvariable => \$Routes
	)->pack(
		-side => "left",
		-padx => 5,
		-pady => 5);

=pod
Buttons

Connect - Connect to a remote PPTP server

Disconnect - Disconnect from the remote PPTP server

Write - Write a configuration file

Quit - Terminates the running pptp daemon and pptp_fe.pl program.
=cut

my $Button_Frame = $Main->Frame->pack(-fill => 'x', -pady => 5);
 
my $Disconnect_Button;
my $Connect_Button;
my $Read_Button;
my $Write_Button;
my $Quit_Button;

$Connect_Button = $Button_Frame->Button(
	-text => "Connect",
	-command =>
		sub {
			update_config();
			syswrite(COMMAND_WRITE, "c\n");

			$Connect_Button->configure(-state => "disabled");
			$Disconnect_Button->configure(-state => "normal");
		},
	)->pack(-side => "left", -pady => 5, -padx => 5);

$Disconnect_Button = $Button_Frame->Button(
	-text => "Disconnect",
	-state => "disabled",
	-command =>
		sub {
			syswrite(COMMAND_WRITE, "d\n");

			$Connect_Button->configure(-state => "normal");
			$Disconnect_Button->configure(-state => "disabled");
		}
	)->pack(-side => "left", -pady => 5, -padx => 5);

$Write_Button = $Button_Frame->Button(
	-text => "Write Config",
	-command =>
		sub {
			syswrite(COMMAND_WRITE, "w\n");

		}
	)->pack(-side => "left", -pady => 5, -padx => 5);

$Quit_Button = $Button_Frame->Button(
	-text => "Quit",
	-command =>
		sub {
			syswrite(COMMAND_WRITE, "q\n");

			$Connect_Button->configure(-state => "disabled");
			$Disconnect_Button->configure(-state => "disabled");
			$Quit_Button->configure(-state => "disabled");
		}
	)->pack(-side => "left", -pady => 5, -padx => 5);

my $Log_Window = $Main->Toplevel;
$Log_Window->title("PPTP Log");

my $Log_Widget = $Log_Window->Text(
	-height => 20,
	-width => 80,
	)->pack;


$Log_Widget->fileevent(OUTPUT_READ, "readable", sub {
	my $in = "";
	my $n = sysread(OUTPUT_READ, $in, 1024);
	if ($n == 0) {
		close OUTPUT_READ;
		$Main->destroy;
		exit 0;
	}

	if (!$Get_Current_Config) {
		$Log_Widget->insert("end", $in);
		$Log_Widget->see("end");
	}
	else {
		$Get_Current_Config = 0;

		for my $line (split("\n", $in)) {
			next unless $line =~ /\S/;

			my ($variable, $value) = split(/\s*=\s*/, $line);
			$variable = "\L$variable";

			if ($variable eq "server") {
				$Server = $value;
			}
			elsif ($variable eq "network") {
				$Network = $value;
			}
			elsif ($variable eq "routes") {
				$Routes = $value;
			}
			elsif ($variable eq "debug") {
				$Debug = $value;
			}
		}
	}

	return 1;
});

syswrite(COMMAND_WRITE, "l\n");
$Get_Current_Config = 1;

MainLoop;

sub update_config {

	syswrite(COMMAND_WRITE, "s server = $Server\n");
	syswrite(COMMAND_WRITE, "s network = $Network\n");
	syswrite(COMMAND_WRITE, "s routes = $Routes\n");
	syswrite(COMMAND_WRITE, "s debug = $Debug_Flag\n");
}
