# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson linux-info xdg-utils

DESCRIPTION="A battery monitor panel plugin for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-battery-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-battery-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.50.0:2
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~ACPI_BATTERY"
		linux-info_pkg_setup
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
