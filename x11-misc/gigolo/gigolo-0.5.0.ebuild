# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="a frontend to easily manage connections to remote filesystems using GIO/GVfs"
HOMEPAGE="https://www.uvena.de/gigolo/ https://goodies.xfce.org/projects/applications/gigolo"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-3.14:3"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	rm COPYING || die
	default
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
