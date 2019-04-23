# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BFAIST
DIST_VERSION=1.0.4
inherit perl-module

DESCRIPTION="Web service API to MusicBrainz database"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
PATCHES=( "${FILESDIR}/1.0.2-no-network-testing.patch" )
RDEPEND="
	>=dev-perl/Mojolicious-7.130.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"
