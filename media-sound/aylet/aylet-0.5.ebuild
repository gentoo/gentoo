# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Aylet plays music files in the .ay format"
HOMEPAGE="http://rus.members.beeb.net/aylet.html"
SRC_URI="http://ftp.ibiblio.org/pub/Linux/apps/sound/players/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="gtk"

RDEPEND="
	sys-libs/ncurses:=
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gtk.patch )

src_compile() {
	tc-export CC PKG_CONFIG

	emake aylet CURSES_LIB="$(${PKG_CONFIG} --libs ncurses)"
	use gtk && emake gtk2
}

src_install() {
	dobin aylet
	use gtk && dobin xaylet

	doman aylet.1
	if use gtk; then
		echo '.so aylet.1' > "${ED}"/usr/share/man/man1/xaylet.1 || die
	fi

	einstalldocs
}
