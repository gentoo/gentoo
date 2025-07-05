# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSIMERSON
DIST_VERSION=1.20250203
inherit perl-module

DESCRIPTION="Perl implementation of DMARC"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/Mail-DKIM
		dev-perl/Net-IMAP-Simple
		dev-perl/Net-SMTPS
	)
	dev-perl/Config-Tiny
	>=dev-perl/DBD-SQLite-1.310.0
	>=dev-perl/DBIx-Simple-1.350.0
	dev-perl/Email-MIME
	>=dev-perl/Email-Sender-1.300.32
	dev-perl/Email-Simple
	dev-perl/File-ShareDir
	dev-perl/IO-Socket-SSL
	dev-perl/libwww-perl
	dev-perl/Mail-DKIM
	dev-perl/Net-DNS
	dev-perl/Net-HTTP
	dev-perl/Net-IDN-Encode
	dev-perl/Net-IP
	dev-perl/Net-SMTPS
	dev-perl/Net-SSLeay
	>=dev-perl/Net-Server-2
	>=dev-perl/Socket6-0.230.0
	dev-perl/Test-File-ShareDir
	dev-perl/URI
	dev-perl/XML-LibXML
	>=dev-perl/Regexp-Common-2013031301
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		dev-perl/Net-DNS-Resolver-Mock
		dev-perl/Test-Exception
		dev-perl/Test-Output
	)
"

PERL_RM_FILES=(
	'bin/install_deps.pl'
)

src_test() {
	local my_test_control
	local badfiles=( t/author-*.t )
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel verbose}}
	if ! has network ${my_test_control} ; then
		einfo "Removing network tests w/o DIST_TEST_OVERRIDE~=network";
		badfiles+=(				\
			"t/04.PurePerl.t"	\
			"t/06.Result.t"		\
			"t/09.HTTP.t"		\
			"t/11.Report.Store.t"				\
			"t/17.Report.Aggregate.Schema.t"	\
			"t/22.Report.Send.SMTP.t"			\
		)
	fi
	perl_rm_files "${badfiles[@]}"
	perl-module_src_test
}
