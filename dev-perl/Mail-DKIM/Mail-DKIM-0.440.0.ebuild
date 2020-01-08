# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=0.44
DIST_EXAMPLES=("scripts/*")
inherit perl-module

DESCRIPTION="Signs/verifies Internet mail using DKIM message signatures"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/Crypt-OpenSSL-RSA-0.24
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	dev-perl/Net-DNS
	dev-perl/MailTools
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Net-DNS-Resolver-Mock
		virtual/perl-Test-Simple
		dev-perl/YAML-LibYAML
	)
"
mydoc=("doc/*.txt" "HACKING.DKIM")

src_test(){
	# disable online tests
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Removing network tests w/o DIST_TEST_OVERRIDE=~network"
		perl_rm_files t/{policy,public_key,verifier,dev-manifest}.t
	fi
	perl-module_src_test
}
