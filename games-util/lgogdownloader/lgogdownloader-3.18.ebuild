# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Sude-/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Unofficial GOG.com downloader for Linux"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"

LICENSE="WTFPL-2"
SLOT="0"
IUSE="gui"

RDEPEND="
	>=app-crypt/rhash-1.3.3-r2:0=
	app-text/htmltidy:=
	dev-libs/boost:=[zlib]
	>=dev-libs/jsoncpp-1.7:0=
	dev-libs/tinyxml2:0=
	>=net-misc/curl-7.55:0=[ssl]
	gui? (
		dev-qt/qtbase:6[network,widgets]
		dev-qt/qtwebengine:6[widgets]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qtbase:6 )
"

PATCHES=( "${FILESDIR}/${P}-boost-1.89.patch" ) # bug 963665

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
