# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SCHWIGON
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Handy utf8 tests"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND=""
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
