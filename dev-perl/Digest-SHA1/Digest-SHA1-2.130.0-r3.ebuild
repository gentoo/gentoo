# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=2.13
inherit perl-module

DESCRIPTION="NIST SHA message digest algorithm"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Digest-1.0.0
"
BDEPEND="
	${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
