# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Unofficial GOG.com downloader for Linux"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
SRC_URI="https://github.com/Sude-/${PN}/releases/download/v${PV}/${P}.tar.gz"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui qt5 qt6"
REQUIRED_USE="gui? ( ^^ ( qt5 qt6 ) )"

RDEPEND="
	>=app-crypt/rhash-1.3.3-r2:0=
	app-text/htmltidy:=
	dev-libs/boost:=[zlib]
	>=dev-libs/jsoncpp-1.7:0=
	dev-libs/tinyxml2:0=
	>=net-misc/curl-7.55:0=[ssl]
	gui? (
		qt5? ( dev-qt/qtwebengine:5[widgets] )
		qt6? ( dev-qt/qtwebengine:6[widgets] )
	)
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_GUI=$(usex gui)
	)
	use gui && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=$(usex qt5)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	gunzip "${ED}"/usr/share/man/man1/${PN}.1.gz || die
}
