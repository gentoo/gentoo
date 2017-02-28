# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSIMERSON
DIST_VERSION=1.20150908
inherit perl-module

DESCRIPTION="Perl implementation of DMARC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

PERL_RM_FILES=(
	'bin/install_deps.pl'
)
PATCHES=(
	"${FILESDIR}/no-installdeps-script.patch"
)
RDEPEND="
	!minimal? (
		dev-perl/Net-IMAP-Simple

	)
	dev-perl/CGI
	virtual/perl-CPAN
	virtual/perl-Carp
	dev-perl/Config-Tiny
	>=dev-perl/DBD-SQLite-1.310.0
	>=dev-perl/DBIx-Simple-1.350.0
	virtual/perl-Data-Dumper
	dev-perl/Email-MIME
	dev-perl/Email-Simple
	virtual/perl-Encode
	dev-perl/File-ShareDir
	virtual/perl-Getopt-Long
	dev-perl/HTTP-Message
	virtual/perl-HTTP-Tiny
	virtual/perl-IO
	virtual/perl-IO-Compress
	dev-perl/IO-Socket-SSL
	dev-perl/JSON
	dev-perl/libwww-perl
	dev-perl/Mail-DKIM
	dev-perl/Net-DNS
	dev-perl/Net-HTTP
	dev-perl/Net-IDN-Encode
	dev-perl/Net-IP
	dev-perl/Net-SMTPS
	dev-perl/Net-SSLeay
	>=dev-perl/Net-Server-2
	virtual/perl-Socket
	>=dev-perl/Socket6-0.230.0
	virtual/perl-Sys-Syslog
	dev-perl/Test-File-ShareDir
	dev-perl/URI
	dev-perl/XML-LibXML
	virtual/perl-parent
	>=dev-perl/Regexp-Common-2013031301
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Output
		virtual/perl-Test-Simple
	)
"
src_test() {
	local my_test_control
	perl_rm_files "t/author-critic.t" "t/release-pod-syntax.t"
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if ! has network ${my_test_control} ; then
		einfo "Removing network tests";
		perl_rm_files "t/04.PurePerl.t" "t/06.Result.t" "t/09.HTTP.t" "t/11.Report.Store.t" \
			"t/22.Report.Send.SMTP.t"
	fi
	perl-module_src_test
}
