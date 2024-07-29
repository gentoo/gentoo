#!/usr/bin/env perl

#
# rsynclogparse-extended.pl, version 1.0
# Script for producing daily or hourly stats from an rsync.log, in
# plain text or XML output formats
#
# (C) Tim Haynes <gentoo@stirfried.vegetable.org.uk>, February 2003
# Redistributable under the terms of the BSD licence
# <http://www.opensource.org/licenses/bsd-license.php>
#

$|=1;

#Determine whether we have a commandline option or not
$arg="";
$arg=shift
  if $ARGV[0]=~/^-/;

#Hash of variables to be output and descriptions
%outputVars=(
	     "mirrorid" => "which mirror name this box is",
	     "contact" => "email address to contact the server administrator",
	     "read" => "total bytes read",
	     "wrote" => "total bytes served",
	     "total" => "total bytes both directions",
	     "count" => "number of connections",
	     "meanxfer" => "mean transfer size",
	     "biggestXfer" => "biggest individual transfer",
	     "speedupavg" => "mean speedup-a-like ratio for all conns",
	     "avgbandwidth" => "mean bandwith reequirement over 1d",
	     "interval" => "most recent n-seconds' worth of data",
	     "maxconns" => "number of times max-conns reached",
	     "percmaxconns" => "percentage of connections rejected",
	     "configmaxconns" => "max concurrent connections configured",
	     "timestamp" => "Current time these stats were generated"
	    );

#Initialise all the above to 0
map { $$_ =0 ; } keys %outputVars;

#Set fields for this specific server
$mirrorid="rsync1.uk.gentoo.org";
$contact="gentoo\@stirfried.vegetable.org.uk";
$configmaxconns=5;

$timestamp=time();

#Determine if we're doing a daily or hourly thing
$interval=3600;
$interval=2600*24 
  if $arg=~/d/;

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime(time);
$now=dateToTstamp(sprintf("%04d/%02d/%02d %02d:%02d:%02d",
			  $year+1900, $mon+1, $mday, $hour, $min, $sec));


#Read in all remaining files on commandline and stdin
while (<>) {
  chomp;

  if (m#^((\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+))#) {  
      $tstamp=dateToTstamp($1);
    }

    next			# skip too-old log entries
      if $tstamp < ($now-$interval);

  $maxconns++
    if /max connections .\d+. reached/oi;

  /wrote (\d+) bytes.*read (\d+) bytes.*size (\d+)/oi
    or next;

  $wrote+=$1;			#running total of outgoing
  $read+=$2;			#running total of incoming
  $volumesize=$3;        	#total size of the volume, serversize
  $localtotal=$1 + $2;
  $speedupsum+=$volumesize/$localtotal;	#running total of "speedup" ratios
  $count++;
  $biggestXfer=($localtotal>$biggestXfer)?$localtotal:$biggestXfer;
}

#Compute a few things
$total=$read+$wrote;
$speedupavg=$speedupsum/$count;	#average speedup ratio
$meanxfer=$total/$count;	#mean-size xfer per connection
$avgbandwidth=$total/$interval; #mean bandwith consumed over this interval
$percmaxconns=100*$maxconns/($count+$maxconns);

#Choice of output format
$arg =~/xml/ ? &outputXML : &outputText;

1;

################

sub outputText {
  foreach $i ( keys %outputVars ) {
    printf("%-20s: $$i\n", $i);
  }
}


sub outputXML {
  print "<xml>\n  <rsyncstats>\n";
  foreach $i ( keys %outputVars ) {
    if ($arg=~/v/o) {
      print "    <$i desc=\"$outputVars{$i}\">$$i</$i>\n";
    } else {
      print "    <$i>$$i</$i>\n";
    }
  }
  print "  </rsyncstats>\n</xml>\n";
}


sub dateToTstamp {
  my $str=shift;

  $str =~ m#^(\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+)#;  

  $tstamp=$6 + 60*$5 + 3600*$4 + 3600*24*$3 +
    3600*24*31*$2 + 3600*24*365*($1-1975);

  return $tstamp;
}
