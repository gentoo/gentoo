# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PJACKLAM
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="What BigInts are before they become big"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=virtual/perl-Math-BigInt-1.999.819
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-0.140.0
	test? (
		>=virtual/perl-Math-BigRat-0.140.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"

src_test() {
	local bad_files=( "t/pod_cov.t" "t/pod.t" )
	perl_rm_files "${bad_files[@]}"
	perl-module_src_test
}
