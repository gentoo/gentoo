# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A panel plug-in to take periodical breaks from the computer"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-time-out-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libX11
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/xfce4-panel-4.12:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

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
