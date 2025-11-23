# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Library to control MPRIS2 compatible players"
HOMEPAGE="https://github.com/matiasdelellis/libmpris2client"
SRC_URI="https://github.com/matiasdelellis/${PN}/releases/download/V${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS NEWS README TODO )

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
