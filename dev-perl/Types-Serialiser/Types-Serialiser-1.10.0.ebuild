# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="simple data types for common serialisation formats"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/common-sense
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
