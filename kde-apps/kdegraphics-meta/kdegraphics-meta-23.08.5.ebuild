# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="https://apps.kde.org/graphics/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="color-management scanner +screencast"

RDEPEND="
	>=kde-apps/gwenview-${PV}:5
	>=kde-apps/kamera-${PV}:5
	>=kde-apps/kcolorchooser-${PV}:5
	>=kde-apps/kdegraphics-mobipocket-${PV}:5
	>=kde-apps/kolourpaint-${PV}:5
	>=kde-apps/kruler-${PV}:5
	>=kde-apps/libkdcraw-${PV}:5
	>=kde-apps/libkexiv2-${PV}:5
	>=kde-apps/okular-${PV}:5
	>=kde-apps/svgpart-${PV}:5
	>=kde-apps/thumbnailers-${PV}:5
	color-management? ( >=kde-misc/colord-kde-${PV}:5 )
	scanner? (
		>=kde-apps/libksane-${PV}:5
		>=kde-misc/skanlite-${PV}:5
		>=media-gfx/skanpage-${PV}:5
	)
	screencast? ( >=kde-apps/spectacle-${PV}:* )
"
