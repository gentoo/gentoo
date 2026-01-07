# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUDREYT
DIST_VERSION=12.0
inherit perl-module

DESCRIPTION="East Asian Width properties"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
