# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="https://apps.kde.org/graphics/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="color-management scanner +screencast +webengine"

RDEPEND="
	>=kde-apps/gwenview-${PV}:*
	>=kde-apps/kamera-${PV}:*
	>=kde-apps/kcolorchooser-${PV}:*
	>=kde-apps/kdegraphics-mobipocket-${PV}:*
	>=kde-apps/kolourpaint-${PV}:*
	>=kde-apps/kruler-${PV}:*
	>=kde-apps/libkdcraw-${PV}:*
	>=kde-apps/libkexiv2-${PV}:*
	>=kde-apps/okular-${PV}:*
	>=kde-apps/svgpart-${PV}:*
	>=kde-apps/thumbnailers-${PV}:*
	color-management? ( >=kde-misc/colord-kde-${PV}:* )
	scanner? (
		>=kde-apps/libksane-${PV}:*
		>=kde-misc/skanlite-${PV}:*
		webengine? ( >=media-gfx/skanpage-${PV}:* )
	)
	screencast? ( >=kde-apps/spectacle-${PV}:* )
"
