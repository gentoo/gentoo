# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DJZORT
DIST_VERSION=4.4002
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="A client for the Bugzilla web services API."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DateTime-Format-ISO8601
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTime-TimeZone
	virtual/perl-Encode
	virtual/perl-File-Spec
	dev-perl/HTTP-CookieJar
	virtual/perl-HTTP-Tiny
	virtual/perl-MIME-Base64
	dev-perl/URI
	dev-perl/XML-Parser
	dev-perl/XML-Writer
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		dev-perl/Clone
		virtual/perl-Data-Dumper
		dev-perl/DateTime
		dev-perl/IO-Socket-SSL
		dev-perl/Test-RequiresInternet
		virtual/perl-Test-Simple
		dev-perl/Text-Password-Pronounceable
	)
"

src_test() {
	has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}} && export TEST_AUTHOR=1
	perl_rm_files t/author-* t/release-*
	perl-module_src_test
}
