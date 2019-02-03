# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="UI abstraction library - Qt plugin"
HOMEPAGE="https://github.com/libyui/libyui-qt"
SRC_URI="https://github.com/libyui/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"

IUSE="static-libs"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libyui:${SLOT}
"
# Only Boost headers are needed
# QtSvg headers only required, no linking
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-qt/qtsvg:5
"

PATCHES=( "${FILESDIR}/${PN}-2.46.21-norpc.patch" )

src_prepare() {
	cp "${EPREFIX}/usr/share/libyui/buildtools/CMakeLists.common" CMakeLists.txt || die

	# TODO: set proper docs deps and USE flag for building them
	sed -i -e '/SET_AUTODOCS/d' CMakeLists.txt || die 'sed on CMakeLists.txt failed'
	sed -i -e 's/src examples/src/' PROJECTINFO.cmake || die 'sed on PROJECTINFO.cmake failed'

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_EXAMPLES=OFF
		-DENABLE_WERROR=OFF
		-DDOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DRESPECT_FLAGS=ON
		-DENABLE_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}
