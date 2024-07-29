# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Friendlier flags for B"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
