# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

RESTRICT="binchecks strip"

KMNAME="kdeartwork"
KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5

DESCRIPTION="Wallpapers from KDE"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
"
RDEPEND="!kde-apps/kdeartwork-wallpapers:4"

PATCHES=( "${FILESDIR}/${P}-kf5-port.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
		-DBUILD_wallpapers=TRUE
		-DBUILD_HighResolutionWallpapers=TRUE
	)

	kde5_src_configure
}
