# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="https://kde.org/applications/graphics/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="scanner"

RDEPEND="
	>=kde-apps/gwenview-${PV}:${SLOT}
	>=kde-apps/kamera-${PV}:${SLOT}
	>=kde-apps/kcolorchooser-${PV}:${SLOT}
	>=kde-apps/kdegraphics-mobipocket-${PV}:${SLOT}
	>=kde-apps/kipi-plugins-${PV}:${SLOT}
	>=kde-apps/kolourpaint-${PV}:${SLOT}
	>=kde-apps/kruler-${PV}:${SLOT}
	>=kde-apps/libkdcraw-${PV}:${SLOT}
	>=kde-apps/libkexiv2-${PV}:${SLOT}
	>=kde-apps/libkipi-${PV}:${SLOT}
	>=kde-apps/okular-${PV}:${SLOT}
	>=kde-apps/spectacle-${PV}:${SLOT}
	>=kde-apps/svgpart-${PV}:${SLOT}
	>=kde-apps/thumbnailers-${PV}:${SLOT}
	scanner? ( >=kde-apps/libksane-${PV}:${SLOT} )
"
