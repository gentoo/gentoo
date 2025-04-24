# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic

DESCRIPTION="Glurp is a GTK2 based graphical client for the Music Player Daemon"
HOMEPAGE="https://sourceforge.net/projects/glurp/"
SRC_URI="https://downloads.sourceforge.net/glurp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	media-libs/libmpd:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# bug #943858
	append-cflags -std=gnu17

	econf $(use_enable debug)
}

src_install() {
	default

	doicon "${FILESDIR}"/${PN}.svg
	make_desktop_entry glurp Glurp glurp AudioVideo
}
