# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A panel plug-in for disk usage and performance statistics"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-diskperf-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=x11-libs/gtk+-3.16.0:3
	>=xfce-base/libxfce4ui-4.14:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.14:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.14:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
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
