# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JHOBLITT
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Create DateTime objects with sub-second current time resolution"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DateTime"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
PATCHES=("${FILESDIR}/${P}-datetimelocale.patch" )
