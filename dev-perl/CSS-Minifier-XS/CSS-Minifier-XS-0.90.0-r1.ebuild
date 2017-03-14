# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="GTERMARS"
DIST_VERSION="0.09"

inherit perl-module

DESCRIPTION="XS based CSS minifier"

SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder"
RDEPEND=""
