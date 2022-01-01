# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=1.20200907
DIST_EXAMPLES=("scripts/*")
inherit perl-module

DESCRIPTION="Signs/verifies Internet mail using DKIM message signatures"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~sparc"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Crypt-OpenSSL-RSA-0.240.0
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	dev-perl/MailTools
	dev-perl/Mail-AuthenticationResults
	dev-perl/Net-DNS
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Net-DNS-Resolver-Mock
		virtual/perl-Test-Simple
		dev-perl/Test-RequiresInternet
		dev-perl/YAML-LibYAML
	)
"

mydoc=("doc/*.txt" "HACKING.DKIM")

src_test() {
	# disable online tests
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Removing network tests w/o DIST_TEST_OVERRIDE=~network"
		perl_rm_files t/{policy,public_key,verifier,dev-manifest}.t
	fi
	perl-module_src_test
}
