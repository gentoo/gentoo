# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Panel plugin to put the maximized window title and window buttons on the panel"
HOMEPAGE="https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libwnck-3.22:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
