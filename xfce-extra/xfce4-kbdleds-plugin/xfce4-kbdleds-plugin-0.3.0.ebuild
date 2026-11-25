# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

DESCRIPTION="A panel plug-in to show state of Caps, Num and Scroll Lock keys"
HOMEPAGE="https://github.com/oco2000/xfce4-kbdleds-plugin"
SRC_URI="
	https://github.com/oco2000/xfce4-kbdleds-plugin/archive/${P}.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	xfce-base/libxfce4ui:=
	xfce-base/libxfce4util:=
	xfce-base/xfce4-panel
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
# for eautoreconf
BDEPEND+="
	dev-build/xfce4-dev-tools
"

src_prepare() {
	default
	NOCONFIGURE=1 xdt-autogen || die
}

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
