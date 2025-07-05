# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DJZORT
DIST_VERSION=4.4004
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="A client for the Bugzilla web services API"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/DateTime-Format-ISO8601
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTime-TimeZone
	dev-perl/HTTP-CookieJar
	dev-perl/URI
	dev-perl/XML-Parser
	dev-perl/XML-Writer
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		dev-perl/Clone
		dev-perl/DateTime
		dev-perl/IO-Socket-SSL
		dev-perl/Test-RequiresInternet
		dev-perl/Text-Password-Pronounceable
	)
"
PERL_RM_FILES=(
	t/release-distmeta.t
	t/release-kwalitee.t
	t/release-unused-vars.t
	t/author-critic.t
	t/author-eof.t
	t/author-eol.t
	t/author-no-breakpoints.t
	t/author-no-tabs.t
	t/author-pod-syntax.t
	t/author-portability.t
)
src_test() {
	has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}} && export TEST_AUTHOR=1
	perl-module_src_test
}
