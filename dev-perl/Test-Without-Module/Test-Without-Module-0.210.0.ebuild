# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CORION
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Test fallback behaviour in absence of modules"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=""
BDEPEND="virtual/perl-ExtUtils-MakeMaker"
