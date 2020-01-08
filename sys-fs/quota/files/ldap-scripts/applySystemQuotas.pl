#!/usr/bin/perl -w

# $0 -b "ou=People,dc=borgia,dc=com" -F '(attr=value)'

# Synopsis
# applyQuotas.pl is a script solely for making the quota set within LDAP take
# affect by running the linuxquota tool edquota with the figures set in LDAP.
# This tool is capable of applying standard LDAP filters to the user-supplied
# base DN for applying multiple users' quotas at once. 

# Examples:
# Apply the quotas using the linuxquota tool edquota for user stefan
# ./applySystemQuotas.pl -b "uid=stefan,ou=People,dc=borgia,dc=com"
#
# Apply the quotas using the linuxquota tool edquota for all People with description of Student
# ./applySystemQuotas.pl -b "ou=People,dc=borgia,dc=com" -F "(description=Student)"

use strict;
use Net::LDAP;
use Getopt::Long;

chomp(my $Password = `cat /etc/ldap.secret`);
my $Host = 'localhost';
my $Port = '389';
my $BindDN = 'cn=Manager,dc=borgia,dc=com';
my $SSL = 0;
my $edquota_editor = '/usr/sbin/edquota_editor';
my $edquota = '/usr/sbin/edquota';

my $b = '';
my $F = '';
GetOptions(
        'b=s' => \$b,
	'F=s' => \$F,
);

die "Usage: $0 -b basedn [-F '(extrafilter)']\n" unless $b;

my $ldap = connectLDAP();

my $search;
$search = $ldap->search(
	base => $b,
	filter => "(&(objectClass=systemQuotas)$F)",
	attrs => ['uid', 'quota'],
);
$search->code && die $search->error;
my $i = 0;
my $max = $search->count;
for ( $i=0; $i<$max; $i++ ) {
	my $entry = $search->entry($i);
	my $editor = $ENV{'VISUAL'} if $ENV{'VISUAL'};
	$ENV{'VISUAL'} = $edquota_editor;
	$ENV{'QUOTA_USER'} = $entry->get_value('uid');
	# Delete all existing quotas for QUOTA_USER
	$ENV{'QUOTA_FILESYS'} = '*';
	$ENV{'QUOTA_SBLOCKS'} = 0;
	$ENV{'QUOTA_HBLOCKS'} = 0;
	$ENV{'QUOTA_SFILES'} = 0;
	$ENV{'QUOTA_HFILES'} = 0;
	print "$ENV{'QUOTA_USER'}: $ENV{'QUOTA_FILESYS'}:$ENV{'QUOTA_SBLOCKS'},$ENV{'QUOTA_HBLOCKS'},$ENV{'QUOTA_SFILES'},$ENV{'QUOTA_HFILES'}\n";
	qx(/usr/sbin/edquota -u $ENV{'QUOTA_USER'});
	my @quotas = $entry->get_value('quota');
	if ( $#quotas >= 0 ) {
		foreach ( @quotas ) {
			my @quota = split /:/;
			$ENV{'QUOTA_FILESYS'} = $quota[0];
			$ENV{'QUOTA_SBLOCKS'} = $quota[1];
			$ENV{'QUOTA_HBLOCKS'} = $quota[2];
			$ENV{'QUOTA_SFILES'} = $quota[3];
			$ENV{'QUOTA_HFILES'} = $quota[4];
			print "$ENV{'QUOTA_USER'}: $ENV{'QUOTA_FILESYS'}:$ENV{'QUOTA_SBLOCKS'},$ENV{'QUOTA_HBLOCKS'},$ENV{'QUOTA_SFILES'},$ENV{'QUOTA_HFILES'}\n";
			qx($edquota -u $ENV{'QUOTA_USER'});
		}
	}
	if ($editor) {
		$ENV{'VISUAL'} = $editor;
	}
	else {
		delete $ENV{'VISUAL'};
	}
}
$search = $ldap->unbind;

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
