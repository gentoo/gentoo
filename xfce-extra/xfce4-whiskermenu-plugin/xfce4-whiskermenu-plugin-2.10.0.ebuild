# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Alternate application launcher for Xfce"
HOMEPAGE="https://gottcode.org/xfce4-whiskermenu-plugin/"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv x86"
IUSE="accountsservice wayland"

# TODO: remove exo once we dep on libxfce4ui >= 4.21.0
DEPEND="
	virtual/libintl
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/exo-4.16.0:=
	>=xfce-base/garcon-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
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
	local emesonargs=(
		$(meson_feature accountsservice)
		$(meson_feature wayland gtk-layer-shell)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
