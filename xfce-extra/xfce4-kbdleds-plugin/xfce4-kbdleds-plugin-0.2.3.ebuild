# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A panel plug-in to show state of Caps, Num and Scroll Lock keys"
HOMEPAGE="https://github.com/oco2000/xfce4-kbdleds-plugin"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	xfce-base/libxfce4ui:=
	xfce-base/libxfce4util:=
	xfce-base/xfce4-panel"
DEPEND=${RDEPEND}
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

# https://github.com/oco2000/xfce4-kbdleds-plugin/pull/7
PATCHES=( "${FILESDIR}/${P}-xfce-4.16.patch" )

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
