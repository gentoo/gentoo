# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=EVDB
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Simple progess bars"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Term-ProgressBar-Quiet
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
