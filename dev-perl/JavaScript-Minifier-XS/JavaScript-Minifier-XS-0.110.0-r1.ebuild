# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="GTERMARS"
DIST_VERSION="0.11"

inherit perl-module

DESCRIPTION="XS based JavaScript minifier"

SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=dev-perl/Module-Build-0.420.0
	virtual/perl-ExtUtils-CBuilder
"
RDEPEND=""
