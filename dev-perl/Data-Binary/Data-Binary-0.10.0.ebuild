# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SNKWATT
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Simple detection of binary versus text in strings"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
