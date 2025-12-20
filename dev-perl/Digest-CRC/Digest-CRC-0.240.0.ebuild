# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OLIMAUL
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="Generic CRC functions"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
