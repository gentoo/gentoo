# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=3.24
inherit perl-module

DESCRIPTION="Data tables useful in parsing HTML"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.460.0
"
