# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Music Player Daemon (mpd) panel plugin"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-mpc-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-mpc-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"

DEPEND="
	>=dev-libs/glib-2.60.0
	media-libs/libmpd:=
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/xfce4-panel-4.13.5:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	econf --enable-libmpd
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
