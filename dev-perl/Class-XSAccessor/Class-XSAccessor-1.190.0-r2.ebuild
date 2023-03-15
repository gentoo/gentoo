# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="Generate fast XS accessors without runtime compilation"
# License note: perl 5-or-newer
# https://bugs.gentoo.org/718946#c6
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Time-HiRes
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	!dev-perl/Class-XSAccessor-Array
	test? (
		virtual/perl-Test-Simple
	)
"
src_compile() {
	mymake=( "OPTIMIZE=${CFLAGS}" )
	perl-module_src_compile
}
