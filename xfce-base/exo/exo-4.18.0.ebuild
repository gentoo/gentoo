# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Extensions, widgets and framework library with session support for Xfce"
HOMEPAGE="
	https://docs.xfce.org/xfce/exo/start
	https://gitlab.xfce.org/xfce/exo/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/libxfce4ui-4.15.1:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.17.2:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/gtk-doc-am
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.16.0
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
