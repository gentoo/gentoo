# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edos2unix xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/libarchive:=
	dev-db/sqlite:3
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets]
	x11-libs/libX11
	x11-libs/libxcb:=
	x11-libs/xcb-util-keysyms
"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme
"
BDEPEND="kde-frameworks/extra-cmake-modules"

PATCHES=(
	"${FILESDIR}/disable-werror.patch"
	"${FILESDIR}/qt6.patch"
	"${FILESDIR}/add-missing-qt-components.patch"
)

src_prepare() {
	edos2unix "${S}/assets/freedesktop/org.zealdocs.zeal.desktop"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DZEAL_RELEASE_BUILD=ON
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
