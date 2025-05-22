# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-any-r1 xdg-utils

DESCRIPTION="Panel plugin to put the maximized window title and window buttons on the panel"
HOMEPAGE="https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.64.0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libwnck-3.22:3
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
# dev-libs/glib for glib-compile-resources
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.64.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
