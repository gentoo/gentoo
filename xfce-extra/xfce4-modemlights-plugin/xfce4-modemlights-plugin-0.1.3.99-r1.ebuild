# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib gnome2-utils

DESCRIPTION="A panel plug-in intended to simplify establishing a ppp connection"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-modemlights-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
