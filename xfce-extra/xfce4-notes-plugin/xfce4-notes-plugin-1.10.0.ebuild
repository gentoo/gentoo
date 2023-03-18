# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Xfce4 panel sticky notes plugin"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-notes-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-notes-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/$(ver_cut 1-2)/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.30:2
	>=x11-libs/gtk+-3.22:3
	>=xfce-base/libxfce4ui-4.14:=
	>=xfce-base/libxfce4util-4.14:=
	>=xfce-base/xfce4-panel-4.14:=
	>=xfce-base/xfconf-4.14:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
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
