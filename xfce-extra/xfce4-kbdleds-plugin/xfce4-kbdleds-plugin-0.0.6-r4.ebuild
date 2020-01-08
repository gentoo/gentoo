# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A panel plug-in to show state of Caps, Num and Scroll Lock keys"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-kbdleds-plugin"
SRC_URI="http://compas.com.ua/oco/file/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.8
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]
	>=x11-libs/gtk+-2.20:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
