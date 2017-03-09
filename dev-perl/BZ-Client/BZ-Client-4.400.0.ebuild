# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DJZORT
DIST_VERSION=4.4
inherit perl-module

DESCRIPTION="A client for the Bugzilla web services API."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/DateTime-Format-ISO8601
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTime-TimeZone
	virtual/perl-Encode
	virtual/perl-File-Spec
	dev-perl/HTTP-CookieJar
	virtual/perl-HTTP-Tiny
	dev-perl/URI
	dev-perl/XML-Parser
	dev-perl/XML-Writer
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Clone
		virtual/perl-Data-Dumper
		dev-perl/DateTime
		dev-perl/Test-RequiresInternet
		virtual/perl-Test-Simple
		dev-perl/Text-Password-Pronounceable
	)
"

src_test() {
	local bad_files my_test_control
	bad_files=(
		t/author-*
		t/release-*
	)
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if ! has network ${my_test_control} ; then
		bad_files+=(
			# Fail without network access
			t/200bug.t t/300classification.t
			# Do discovery probes
			t/400component.t t/500group.t
		)
	fi
	perl_rm_files "${bad_files[@]}"
	perl-module_src_test
}
