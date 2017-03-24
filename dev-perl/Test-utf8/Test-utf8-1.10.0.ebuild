# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKF
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Handy utf8 tests"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
