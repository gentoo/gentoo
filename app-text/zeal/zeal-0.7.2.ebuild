# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+X"

DEPEND="
	app-arch/libarchive:=
	dev-cpp/cpp-httplib:=
	dev-db/sqlite:3
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets]
	X? (
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme
"
BDEPEND="kde-frameworks/extra-cmake-modules"

PATCHES=(
	"${FILESDIR}/disable-werror-0.7.2.patch"
)

src_configure() {
	local mycmakeargs=(
		-DZEAL_RELEASE_BUILD=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex X no yes)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
