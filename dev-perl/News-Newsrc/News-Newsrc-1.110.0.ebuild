# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SWMCD
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="Manage newsrc files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc x86"
IUSE=""

RDEPEND=">=dev-perl/Set-IntSpan-1.70.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
