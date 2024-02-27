# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Archive plug-in for the Thunar filemanager"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/archive
	https://gitlab.xfce.org/thunar-plugins/thunar-archive-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/exo-0.10:=
	>=xfce-base/thunar-1.7:=
"
RDEPEND="
	${DEPEND}
"
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
