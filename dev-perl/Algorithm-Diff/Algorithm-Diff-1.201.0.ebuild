# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJBS
DIST_VERSION=1.201
DIST_EXAMPLES="bin/*"
inherit perl-module

DESCRIPTION="Compute intelligent differences between two files / lists"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
