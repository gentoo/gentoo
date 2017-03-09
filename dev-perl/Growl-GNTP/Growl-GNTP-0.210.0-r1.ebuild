# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATTN
DIST_VERSION=0.21
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Perl implementation of GNTP Protocol (Client Part)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	examples? ( virtual/perl-Encode )
	>=dev-perl/Crypt-CBC-2.290.0
	>=dev-perl/Data-UUID-0.149.0
	>=virtual/perl-Digest-MD5-2.360.0
	>=virtual/perl-Digest-SHA-5.450.0
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0"

src_test() {
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if ! has 'network' ${my_test_control}; then
		einfo "Network testing disabled"
		perl_rm_files "t/01_simple.t"
	fi
	perl-module_src_test
}
