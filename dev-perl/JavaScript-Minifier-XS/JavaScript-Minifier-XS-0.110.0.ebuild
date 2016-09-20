# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="GTERMARS"
MODULE_VERSION="0.11"

inherit perl-module

DESCRIPTION="XS based JavaScript minifier"

LICENSE="Artistic GPL-1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-perl/Module-Build-0.420.0
	virtual/perl-ExtUtils-CBuilder
"
RDEPEND=""

SRC_TEST="do"
