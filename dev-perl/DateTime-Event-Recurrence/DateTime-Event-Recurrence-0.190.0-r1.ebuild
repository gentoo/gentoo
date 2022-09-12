# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FGLOCK
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="DateTime::Set extension for create basic recurrence sets"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-perl/DateTime-0.270.0
	>=dev-perl/DateTime-Set-0.360.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
