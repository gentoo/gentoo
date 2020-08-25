# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="Generate fast XS accessors without runtime compilation"
# License note: perl 5-or-newer
# https://bugs.gentoo.org/718946#c6
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
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
