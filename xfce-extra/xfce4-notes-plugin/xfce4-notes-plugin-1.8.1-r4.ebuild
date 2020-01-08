# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Xfce4 panel sticky notes plugin"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-notes-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.24:2
	>=x11-libs/gtk+-2.20:2
	<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.10:=
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]
	>=xfce-base/xfconf-4.10:=
	dev-libs/libunique:1="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

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
