# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info xdg-utils

DESCRIPTION="A battery monitor panel plugin for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-battery-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE="kernel_linux"

RDEPEND=">=dev-libs/glib-2.24:2
	>=x11-libs/gtk+-3.16:3
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.8:=
	>=xfce-base/xfce4-panel-4.12:="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~ACPI_BATTERY"
		linux-info_pkg_setup
	fi
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
