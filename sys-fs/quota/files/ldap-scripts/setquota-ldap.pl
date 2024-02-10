#!/usr/bin/perl

# A Perl wrapper for setquota utility which updates LDAP accordingly.

# /etc/fstab: usrquota,grpquota
# mount -o remount /f/s
# touch /f/s/aquota.{user,group}
# chmod 600 /f/s/aquota.{user,group}
# quotacheck -cguvamf

use strict;
use warnings;
use Net::LDAP;
use Net::LDAP::Entry;
use Getopt::Long;
Getopt::Long::Configure ("bundling");

my $help = $#ARGV >= 0 ? 0 : 1;
my $ldaphost = 'localhost';
my $passwordfile = '';
my $password = '';
my $binddn = $ENV{BINDDN};
my $basedn = $ENV{BASEDN};
my $oc = 'systemQuotas';
my $attr = 'quota';
my %Q = ();
my $F = 'cn=*';
GetOptions(
        'help|?' => \$help,
        'oc|o=s' => \$oc,
        'attr|a=s' => \$attr,
        'quota|Q=s' => \%Q,
        'filter|F=s' => \$F,
        'ldaphost|h=s' => \$ldaphost,
        'basedn|b=s' => \$basedn,
        'binddn|D=s' => \$binddn,
        'password|w=s' => \$password,
        'passwordfile|W=s' => \$passwordfile,
);
die "Usage: $0 -b basedn [-o objectClass] [-a attr] [-F '(extrafilter)'] [-Q
/f/s=sb:hb:gb:sf:hf:gf ...]\n" if $help;
%Q = checkQ(%Q);

my ($ldap, $bind);
if ( $ldap = Net::LDAP->new($ldaphost, version => 3, timeout => 3) ) {
        if ( $binddn && $password ) {
                $bind = $ldap->bind($binddn, password=>$password);
        } elsif ( $binddn && $passwordfile ){
                $bind = $ldap->bind($binddn, password=>bindpw($passwordfile));
        } else {
                $bind = $ldap->bind();
        }
        die "Unable to connect to LDAP\n" if $bind->code;
        undef $passwordfile;
} else {
        die "Unable to connect to LDAP\n";
}

my $search = $ARGV[0] ? $ldap->search(base=>$basedn, filter=>"uid=$ARGV[0]") : $ldap->search(base=>$basedn, filter=>$F);
if ( $search->code ) {
        die "LDAP Error: ", error($search), "\n";
} elsif ( $search->count <= 0 ) {
        die "0 results found in LDAP\n";
} else {
        my $i = 0;
        for ( $i=0; $i<$search->count; $i++ ) {
                my $entry = $search->entry($i);
                my @oc = $entry->get_value('objectClass');
                # objectClass: $oc
                unless ( grep { /^$oc$/ } @oc ) {
                        my $modify = $ldap->modify($entry->dn, add => {objectClass => $oc});
                        if ( $modify->code ) {
                                print STDERR "Failed to add objectClass $oc:", error($modify), "\n";
                        }
                }
                # $attr: /f/s=sb:hb:sf:hf
                if ( $entry->exists($attr) ) {
                        my @attr = $entry->get_value($attr);
                        if ( keys %Q ) {
                                foreach my $fs ( keys %Q ) {
                                        foreach ( @attr ) {
                                                next unless /^$fs=/;
                                                my $modify = $ldap->modify($entry->dn, delete => {$attr => "$_"});
                                                if ( $modify->code ) {
                                                        print STDERR "Failed to delete $attr: $_: ", error($modify), "\n";
                                                }
                                        }
                                        my $modify = $ldap->modify($entry->dn, add => {$attr => "$fs=$Q{$fs}"});
                                        if ( $modify->code ) {
                                                print STDERR "Failed to add $attr: $fs=$Q{$fs}: ", error($modify), "\n";
                                        } else {
                                                print STDERR "Failed to setquota: $fs=$Q{$fs}\n" if setquota($entry->get_value('uid'), $fs, $Q{$fs});
                                        }
                                }
                        } else {
                                my $modify = $ldap->modify($entry->dn, delete => [($attr)]);
                                if ( $modify->code ) {
                                        print STDERR "Failed to delete $attr: ", error($modify), "\n";
                                } else {
                                        foreach ( @attr ) {
                                                my ($fs) = m!^(/[^=]*)!;
                                                $Q{$fs} = '0:0:0:0:0:0';
                                                print STDERR "Failed to setquota: $fs=$Q{$fs}\n" if setquota($entry->get_value('uid'), $fs, $Q{$fs});
                                        }
                                }
                        }
                } else {
                        if ( keys %Q ) {
                                foreach my $fs ( keys %Q ) {
                                        my $modify = $ldap->modify($entry->dn, add => {$attr => "$fs=$Q{$fs}"});
                                        if ( $modify->code ) {
                                                print STDERR "Failed to add $attr: $fs=$Q{$fs}: ", error($modify), "\n";
                                        } else {
                                                print STDERR "Failed to setquota: $fs=$Q{$fs}\n" if setquota($entry->get_value('uid'), $fs, $Q{$fs});
                                        }
                                }
                        }
                }
        }
}

sub setquota {
        $_[2] = '0:0:0:0:0:0' unless $_[2];
        $_[2] =~ /^(\d+):(\d+):(\d+):(\d+):(\d+):(\d+)$/;
        qx{/usr/sbin/setquota -u $_[0] $1 $2 $4 $5 $_[1]};
        qx{/usr/sbin/setquota -T -u $_[0] $3 $6 $_[1]};
        return 0;
}

sub checkQ {
        my (%Q) = @_;
        foreach ( keys %Q ) {
                die "$_: invalid format\n" unless m!^(/[^=]*)! && $Q{$_} =~ /^(\d+):(\d+):(\d+):(\d+):(\d+):(\d+)$/;
        }
        return %Q;
}

sub bindpw {
        my ($passwordfile) = @_;
        open P, $passwordfile or die "Can't open passwordfile: $!";
        chomp(my $password = <P>);
        close P;
        return $password;
}

sub error {
        return $_[0]->error, "(", $_[0]->code, ")";
}
