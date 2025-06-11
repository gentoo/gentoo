# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A dict.org querying application and panel plug-in for the Xfce desktop"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-dict/start
	https://gitlab.xfce.org/apps/xfce4-dict/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/libxfce4ui-4.18.0:=
	>=xfce-base/xfce4-panel-4.18.0:=
"
RDEPEND="
	${DEPEND}
"
# dev-libs/glib for glib-compile-resources
BDEPEND="
	>=dev-libs/glib-2.66.0
	dev-util/gdbus-codegen
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
