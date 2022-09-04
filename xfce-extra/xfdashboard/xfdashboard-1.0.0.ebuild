# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Maybe a GNOME shell like dashboard for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfdashboard/start"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.2:3
	>=media-libs/clutter-1.12:1.0=[gtk]
	>=x11-libs/libwnck-3:3=
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXdamage:=
	x11-libs/libXinerama:=
	>=xfce-base/garcon-0.2.0:=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfconf-4.14:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/intltool
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
