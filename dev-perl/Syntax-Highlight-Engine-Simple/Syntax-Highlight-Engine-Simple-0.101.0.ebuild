# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.101
DIST_AUTHOR=AKHUETTEL
inherit perl-module

DESCRIPTION="Simple Syntax Highlight Engine"
IUSE="test"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PATCHES=( "${FILESDIR}/${PN}-0.101-noreadme.patch" )
