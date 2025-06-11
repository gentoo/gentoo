# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A system load plug-in for the Xfce panel"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin
	https://gitlab.xfce.org/panel-plugins/xfce4-cpugraph-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.12.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
