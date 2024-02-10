# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PJACKLAM
DIST_VERSION=1.999842
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Arbitrary size floating point math package"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=virtual/perl-Math-Complex-1.390.0
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"
# TODO: where does this come from?
PDEPEND="
	>=virtual/perl-Math-BigInt-FastCalc-0.500.600
	>=virtual/perl-bignum-0.220.0
	>=virtual/perl-Math-BigRat-0.260.200
"

src_test() {
	perl_rm_files t/author-*.t t/03podcov.t t/00sig.t t/02pod.t
	perl-module_src_test
}
