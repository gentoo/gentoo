# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SCHWIGON
DIST_VERSION=2.24
DIST_SECTION="class-methodmaker"
inherit perl-module

DESCRIPTION="Create generic methods for OO Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
