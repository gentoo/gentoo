# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_P=${P/SoQt/soqt}

HOMEPAGE="https://github.com/coin3d/coin/wiki"
DESCRIPTION="GUI binding for using Coin/Open Inventor with Qt"
SRC_URI="https://github.com/coin3d/soqt/releases/download/v${PV}/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="debug doc qt6"

RDEPEND="
	media-libs/coin
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtopengl:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,opengl,widgets]
	)
"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

S="${WORKDIR}/soqt"

DOCS=(AUTHORS ChangeLog HACKING NEWS README)

src_configure() {
	use debug && append-cppflags -DSOQT_DEBUG=1
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc)
		-DSOQT_BUILD_INTERNAL_DOCUMENTATION=OFF
		-DSOQT_USE_QT6=$(usex qt6)
		-DSOQT_VERBOSE=$(usex debug)
	)
	cmake_src_configure
}
