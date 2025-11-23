# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MUIR
DIST_VERSION=0.912
DIST_SECTION=modules
inherit perl-module

DESCRIPTION="Parse and generate Cisco configuration files"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.70.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
