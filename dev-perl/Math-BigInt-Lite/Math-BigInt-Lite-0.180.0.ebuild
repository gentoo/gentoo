# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PJACKLAM
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="What BigInts are before they become big"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.999.812
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"

src_test() {
	local bad_files=( "t/pod_cov.t" "t/pod.t" )
	perl_rm_files "${bad_files[@]}"
	perl-module_src_test
}
