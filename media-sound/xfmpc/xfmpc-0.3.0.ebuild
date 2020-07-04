# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="Music Player Daemon (MPD) client for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfmpc"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18:2=
	>=media-libs/libmpd-0.15:=
	>=x11-libs/gtk+-3.22:3=
	>=xfce-base/libxfce4ui-4.12:=
	>=xfce-base/libxfce4util-4.12:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog IDEAS NEWS README THANKS )

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
