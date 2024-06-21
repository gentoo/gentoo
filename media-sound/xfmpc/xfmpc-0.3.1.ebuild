# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Music Player Daemon (MPD) client for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/apps/xfmpc/start
	https://gitlab.xfce.org/apps/xfmpc/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.38.0:2=
	>=media-libs/libmpd-0.15.0:=
	>=x11-libs/gtk+-3.22.0:3=
	>=xfce-base/libxfce4ui-4.12.0:=
	>=xfce-base/libxfce4util-4.12.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
