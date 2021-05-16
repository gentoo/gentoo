# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TODDR
DIST_VERSION=2.02
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A UPS Interface Module"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/libwww-perl"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
