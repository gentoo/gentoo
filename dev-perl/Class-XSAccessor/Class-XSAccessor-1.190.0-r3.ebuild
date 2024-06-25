# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="Generate fast XS accessors without runtime compilation"

# License note: perl 5-or-newer
# https://bugs.gentoo.org/718946#c6
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~ppc-macos"

RDEPEND="
	virtual/perl-Time-HiRes
	virtual/perl-XSLoader
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	!dev-perl/Class-XSAccessor-Array
	test? (
		virtual/perl-Test-Simple
	)
"
