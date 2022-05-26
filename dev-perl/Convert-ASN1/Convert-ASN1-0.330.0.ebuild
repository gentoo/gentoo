# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="Standard en/decode of ASN.1 structures"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Math-BigInt-1.997.0
		>=virtual/perl-Test-Simple-0.900.0
	)
"
