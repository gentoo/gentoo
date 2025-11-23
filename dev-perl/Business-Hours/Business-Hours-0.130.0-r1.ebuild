# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=0.13

inherit perl-module

DESCRIPTION="Calculate business hours in a time period"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Set-IntSpan-1.120.0
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
