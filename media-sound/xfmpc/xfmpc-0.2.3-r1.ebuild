# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit xdg-utils

DESCRIPTION="Music Player Daemon (MPD) client for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfmpc"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/0.2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18:2=
	>=media-libs/libmpd-0.15:=
	>=x11-libs/gtk+-2.16:2=
	>=xfce-base/libxfce4ui-4.8:=
	>=xfce-base/libxfce4util-4.8:="
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog IDEAS NEWS README THANKS )
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
