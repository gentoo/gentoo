# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=FGLOCK
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="DateTime::Set extension for create basic recurrence sets"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/DateTime-0.270.0
	>=dev-perl/DateTime-Set-0.360.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
