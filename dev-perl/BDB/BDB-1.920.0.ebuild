# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.92
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Asynchronous Berkeley DB access"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/common-sense
	sys-libs/db:=
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
