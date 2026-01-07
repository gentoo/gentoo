# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt GUI configuration tool for Wine"
HOMEPAGE="https://q4wine.brezblock.org.ua/"
SRC_URI="https://github.com/brezerk/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +ico +iso +wineappdb"

DEPEND="
	dev-qt/qtbase:6[dbus,gui,network,sql,sqlite,ssl,widgets,xml]
	dev-qt/qtsvg:6
	ico? ( >=media-gfx/icoutils-0.26.0 )
"
RDEPEND="${DEPEND}
	app-admin/sudo
	>=sys-apps/which-2.19
	iso? ( sys-fs/fuseiso )
"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( {AUTHORS,Changelog,README}.md )

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug ON OFF)
		-DWITH_ICOUTILS=$(usex ico ON OFF)
		-DWITH_SYSTEM_SINGLEAPP=OFF
		-DWITH_WINEAPPDB=$(usex wineappdb ON OFF)
		-DUSE_BZIP2=OFF
		-DUSE_GZIP=OFF
		-DWITH_DBUS=ON
	)
	cmake_src_configure
}
