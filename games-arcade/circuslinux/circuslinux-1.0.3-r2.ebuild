# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Clone of the Atari 2600 game \"Circus Atari\""
SRC_URI="ftp://ftp.tuxpaint.org/unix/x/circus-linux/src/${P}.tar.gz"
HOMEPAGE="http://www.newbreedsoftware.com/circus-linux/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	tc-export CC
	sed -i 's/-O2//' Makefile.in || die
	sed -i 's/$(pkgdatadir)/$(DESTDIR)&/' data/Makefile.in || die
}

src_configure() {
	tc-export CC
	econf --enable-joystick
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}" install

	newicon data/images/${PN}-icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Circus Linux!"
}
