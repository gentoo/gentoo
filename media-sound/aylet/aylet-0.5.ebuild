# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Aylet plays music files in the .ay format"
HOMEPAGE="http://rus.members.beeb.net/aylet.html"
SRC_URI="http://ftp.ibiblio.org/pub/Linux/apps/sound/players/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="gtk"

RDEPEND="sys-libs/ncurses
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtk.patch
}

src_compile() {
	tc-export CC PKG_CONFIG

	emake ${PN} CURSES_LIB="$( ${PKG_CONFIG} --libs ncurses)"
	use gtk && emake gtk2
}

src_install() {
	dobin ${PN}
	use gtk && dobin x${PN}

	doman ${PN}.1
	use gtk && echo '.so aylet.1' > "${D}"/usr/share/man/man1/xaylet.1

	dodoc ChangeLog NEWS README TODO
}
