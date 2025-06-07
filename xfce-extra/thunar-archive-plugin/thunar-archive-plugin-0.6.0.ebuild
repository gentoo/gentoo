# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Archive plug-in for the Thunar filemanager"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/archive
	https://gitlab.xfce.org/thunar-plugins/thunar-archive-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/thunar-4.18.0:=
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
