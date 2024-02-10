#!/usr/bin/perl -w

# $0 -b "ou=People,dc=borgia,dc=com" -Q /dev/with/quota=0:0:0:0 -F '(attr=value)'

# Synopsis
# setSystemQuotas.pl is a script solely for modifying the quota attribute in
# LDAP.  It expects that the users you intend to have quotas already have the
# systemQuotas objectClass set.
# This tool is capable of applying standard LDAP filters to the user-supplied
# base DN for modifying multiple users' quotas at once.

# Examples:
# Set quota on /dev/sda7 and /dev/sda8 for user stefan
# ./setSystemQuotas.pl -b "uid=stefan,ou=People,dc=borgia,dc=com" -Q /dev/sda7=4000000:4400000:10000:11000 -Q /dev/sda8=4000000:4400000:10000:11000
#
# Set quota on /dev/sda8 for user all People with description of Student
# ./setSystemQuotas.pl -b "ou=People,dc=borgia,dc=com" -Q /dev/sda8=40000:44000:1000:1100 -F "(description=Student)"
#
# Delete quotas for user stefan
# ./setSystemQuotas.pl -b "uid=stefan,ou=People,dc=borgia,dc=com"

use strict;
use Net::LDAP;
use Getopt::Long;

chomp(my $Password = `cat /etc/ldap.secret`);
my $Host = 'localhost';
my $Port = '389';
my $BindDN = 'cn=Manager,dc=borgia,dc=com';
my $SSL = 0;

my $b = '';
my %Q = ();
my $F = '';
GetOptions(
	'b=s' => \$b,
	'Q=s' => \%Q,
	'F=s' => \$F,
);
die "Usage: $0 -b userdn [-F '(extrafilter)'] [-Q /fs=sb:hb:sf:hf ...]\n" unless $b;
foreach ( keys %Q ) {
	local @_ = split /:/, $Q{$_};
	unless ( $#_ == 3 ) {
		print "Ignoring $_: invalid format\n";
		delete $Q{$_};
	}
}

my $ldap = connectLDAP();

my $quota = {};
my $search;
$search = $ldap->search(
        base => $b,
        filter => "(&(objectClass=systemQuotas)$F)",
        attrs => ['*', 'quota'],
);
$search->code && die $search->error;
my $i = 0;
my $max = $search->count;
for ( $i=0; $i<$max; $i++ ) {
        my $entry = $search->entry($i);
	my $dn = $entry->dn;
	if ( keys %Q ) {
		$quota->{$dn} = 1;
		foreach ( $entry->get_value('quota') ) {
			my @quota = split /:/;
			my $fs = shift @quota;
			delete $quota->{$dn} if $quota->{$dn} == 1;
			$quota->{$dn}->{$fs} = join ':', @quota;
		}
	} else {
		$quota->{$dn} = 0;
		delete $quota->{$dn} unless $entry->get_value('quota');
	}
}
	
foreach my $dn ( keys %{$quota} ) {
	if ( ref $quota->{$dn} eq 'HASH' ) {
print STDERR "Modify $dn:\n";
		foreach ( keys %Q ) {
print STDERR "\t$_:$Q{$_}\n";
			$quota->{$dn}->{$_} = $Q{$_};
		}
		my @quota = map { "$_:$quota->{$dn}->{$_}" } keys %{$quota->{$dn}};
		my $modify = $ldap->modify(
			$dn,
			replace => {
				quota => [@quota],
			},
		);
		$modify->code && warn "Failed to modify quota: ", $modify->error, "\n";
	} else {
		if ( $quota->{$dn} == 1 ) {
			delete $quota->{$dn};
print STDERR "Add $dn:\n";
			foreach ( keys %Q ) {
print STDERR "\t$_:$Q{$_}\n";
				$quota->{$dn}->{$_} = $Q{$_}
			}
			my @quota = map { "$_:$quota->{$dn}->{$_}" } keys %{$quota->{$dn}};
			my $modify = $ldap->modify(
				$dn,
				add => {
					quota => [@quota],
				},
			);
			$modify->code && warn "Failed to modify quota: ", $modify->error, "\n";
		} elsif ( $quota->{$dn} == 0 ) {
print STDERR "Delete $dn:\n";
			my $modify = $ldap->modify(
				$dn,
				delete => ['quota'],
			);
			$modify->code && warn "Failed to modify quota: ", $modify->error, "\n";
		}
	}
}
$ldap->unbind;

sub connectLDAP {
        # bind to a directory with dn and password
        my $ldap = Net::LDAP->new(
                $Host,
                port => $Port,
                version => 3,
#                debug => 0xffff,
        ) or die "Can't contact LDAP server ($@)\n";
        if ( $SSL ) {
                $ldap->start_tls(
                        # verify => 'require',
                        # clientcert => 'mycert.pem',
                        # clientkey => 'mykey.pem',
                        # decryptkey => sub { 'secret'; },
                        # capath => '/usr/local/cacerts/'
                ); 
        }
        $ldap->bind($BindDN, password=>$Password);
        return $ldap;
}   
