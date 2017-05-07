# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALINKE
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Transliterates text between writing systems"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
