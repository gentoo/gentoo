# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake xdg-utils

DESCRIPTION="Alternate application launcher for Xfce"
HOMEPAGE="https://gottcode.org/xfce4-whiskermenu-plugin/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
IUSE="accountsservice wayland"

DEPEND="
	virtual/libintl
	x11-libs/gtk+:3
	>=xfce-base/exo-0.12:=
	>=xfce-base/garcon-0.6.4:=
	>=xfce-base/libxfce4ui-4.14:=
	>=xfce-base/libxfce4util-4.14:=
	>=xfce-base/xfce4-panel-4.14:=
	>=xfce-base/xfconf-4.14:=
	accountsservice? (
		>=sys-apps/accountsservice-0.6.45
	)
	wayland? (
		>=gui-libs/gtk-layer-shell-0.7
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

# upstream does fancy stuff in other build types
CMAKE_BUILD_TYPE=Debug

src_configure() {
	local mycmakeargs=(
		-DENABLE_AS_NEEDED=OFF
		-DENABLE_LINKER_OPTIMIZED_HASH_TABLES=OFF
		-DENABLE_DEVELOPER_MODE=OFF
		-DENABLE_LINK_TIME_OPTIMIZATION=OFF
		-DENABLE_ACCOUNTS_SERVICE=$(usex accountsservice)
		-DENABLE_GTK_LAYER_SHELL=$(usex wayland)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
