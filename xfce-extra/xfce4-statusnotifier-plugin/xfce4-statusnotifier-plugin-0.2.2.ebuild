# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A panel area for fd.o Status Notifiers (systray replacement)"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-statusnotifier-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.24
	>=dev-libs/libdbusmenu-16.04.0:=[gtk3]
	>=x11-libs/gtk+-3.18:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfce4-panel-4.12:=
	>=xfce-base/xfconf-4.12:="
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen"

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
