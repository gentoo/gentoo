# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A modern, minimalist docklike taskbar for Xfce"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-docklike-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X wayland"
REQUIRED_USE="|| ( X wayland )"

DEPEND="
	>=dev-libs/glib-2.58.0
	>=x11-libs/gtk+-3.24.0:3[X?,wayland?]
	>=x11-libs/cairo-1.16.0
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/libxfce4windowing-4.19.4:=[X?]
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXi-1.2.0
	)
	wayland? (
		>=gui-libs/gtk-layer-shell-0.7.0
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
