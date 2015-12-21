# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdeartwork"
KDE_AUTODEPS="false"
KDE_SCM="svn"
inherit kde5

DESCRIPTION="Weather aware wallpapers. Changes with weather outside"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)"
RDEPEND="
	$(add_kdeapps_dep kdeartwork-wallpapers)
	!kde-apps/kdeartwork-weatherwallpapers:4
"

PATCHES=( "${FILESDIR}/${P}-kf5-port.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
		-DBUILD_WeatherWallpapers=TRUE
	)

	kde5_src_configure
}
