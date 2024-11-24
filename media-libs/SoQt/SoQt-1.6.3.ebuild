# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="GUI binding for using Coin/Open Inventor with Qt"
HOMEPAGE="https://github.com/coin3d/coin/wiki"
SRC_URI="https://github.com/coin3d/soqt/releases/download/v${PV}/${P/SoQt/soqt}-src.tar.gz"
S="${WORKDIR}/soqt"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="debug doc"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	media-libs/coin
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_configure() {
	use debug && append-cppflags -DSOQT_DEBUG=1
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc)
		-DSOQT_BUILD_INTERNAL_DOCUMENTATION=OFF
		-DSOQT_USE_QT6=ON
		-DSOQT_VERBOSE=$(usex debug)
	)
	cmake_src_configure
}
