# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PJACKLAM
DIST_VERSION=1.7003
inherit perl-module

DESCRIPTION="Use the GMP library for Math::BigInt routines"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=virtual/perl-Math-BigInt-1.999.840
	>=virtual/perl-XSLoader-0.20.0
	>=dev-libs/gmp-4.0.0:0
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.580.0
	test? ( >=virtual/perl-Test-Simple-0.820.0 )
"

src_test() {
	perl_rm_files t/author-*.t t/00sig.t t/02pod.t t/03podcov.t
	perl-module_src_test
}
