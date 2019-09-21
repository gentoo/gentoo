# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Guile Scheme code that wraps the GNOME developer platform"
HOMEPAGE="https://www.gnu.org/software/guile-gnome/"
SRC_URI="https://ftp.gnu.org/pub/gnu/guile-gnome/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/atk
	>=dev-libs/g-wrap-1.9.15
	dev-libs/glib:2
	dev-scheme/guile:12
	dev-scheme/guile-cairo
	dev-scheme/guile-lib
	gnome-base/gconf:2
	gnome-base/gnome-vfs:2
	gnome-base/libbonobo
	gnome-base/libglade:2.0
	gnome-base/libgnomecanvas
	gnome-base/libgnomeui
	gnome-base/orbit:2
	x11-libs/gtk+:2
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#needs guile with networking
RESTRICT=test

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
