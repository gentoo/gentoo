# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Official extensions for PhotoQt"
HOMEPAGE="https://photoqt.org/extensions"
SRC_URI="https://gitlab.com/lspies/photoqt-extensions/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geolocation graphicsmagick histogram +imagemagick"

DEPEND="
	dev-qt/qtbase:6[dbus,gui,network,opengl,sql,sqlite,widgets]
	dev-qt/qtdeclarative:6[opengl]
	dev-qt/qtsvg:6
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx,hdri] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	)
"
RDEPEND="
	${DEPEND}
	~media-gfx/photoqt-${PV}[extensions]
	geolocation? (
		dev-qt/qtlocation:6
		dev-qt/qtpositioning:6[qml]
	)
	histogram? ( dev-qt/qtcharts:6[qml] )
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAPCURRENT=$(usex geolocation)
		-DBUILD_HISTOGRAM=$(usex histogram)
		-DBUILD_CROPIMAGE=$(usex imagemagick)
		-DBUILD_EXPORTIMAGE=$(usex imagemagick)
		-DBUILD_SCALEIMAGE=$(usex imagemagick)
	)

	use imagemagick && mycmakeargs+=(
		-DWITH_GRAPHICSMAGICK=$(usex graphicsmagick $(usex imagemagick))
		-DWITH_IMAGEMAGICK=$(usex imagemagick $(usex !graphicsmagick))
	)

	cmake_src_configure
}
