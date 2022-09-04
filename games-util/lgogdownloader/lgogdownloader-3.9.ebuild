# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Unofficial GOG.com downloader for Linux"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
SRC_URI="https://github.com/Sude-/${PN}/releases/download/v${PV}/${P}.tar.gz"
LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND=">=app-crypt/rhash-1.3.3-r2:0=
	dev-cpp/htmlcxx:0=
	dev-libs/boost:=[zlib]
	>=dev-libs/jsoncpp-1.7:0=
	dev-libs/tinyxml2:0=
	>=net-misc/curl-7.32:0=[ssl]
	gui? ( dev-qt/qtwebengine:5=[widgets] )"

DEPEND="${RDEPEND}"

BDEPEND="sys-apps/help2man
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_GUI=$(usex gui)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	gunzip "${ED}"/usr/share/man/man1/${PN}.1.gz || die
}
