# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALINKE
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="Transliterates text between writing systems"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
