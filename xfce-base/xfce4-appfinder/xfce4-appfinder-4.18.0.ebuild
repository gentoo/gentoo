# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A tool to find and launch installed applications for the Xfce desktop"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-appfinder/start
	https://gitlab.xfce.org/xfce/xfce4-appfinder/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/garcon-0.3:=
	>=xfce-base/libxfce4util-4.15.2:=
	>=xfce-base/libxfce4ui-4.14:=[gtk3(+)]
	>=xfce-base/xfconf-4.14:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
