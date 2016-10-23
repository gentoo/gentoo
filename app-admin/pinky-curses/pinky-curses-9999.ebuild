# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://gitlab.com/void0/pinky-bar.git"

inherit git-r3

DESCRIPTION="Standalone statusbar program utilizing ncurses"
HOMEPAGE="https://gitlab.com/void0/pinky-bar"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	sys-devel/m4
	sys-apps/gawk
	sys-devel/autoconf
	>=sys-devel/automake-1.14.1
"
RDEPEND="
	sys-libs/ncurses
"

src_prepare() {
	default

	einfo 'Generating Makefiles'
	chmod +x bootstrap
	./bootstrap 'gentoo'
}

src_configure() {
	econf \
		--without-alsa \
		--without-x11 \
		--without-mpd \
		--without-net \
		--without-pci \
		--without-dvd \
		--without-sensors \
		--without-weather \
		--with-ncurses \
		--with-colours
}

src_compile() {
	emake 'ncurses'
}

src_install() {
	newbin "${S}"/src/ncurses pinky-curses
}

pkg_postinst() {
	einfo 'The program is not tied to pinky-bar. Heres some short introduction:'
	einfo 'Depending whether you enabled the colours: ^B - Blue , ^M - Magenta , ^Y - Yellow'
	einfo 'And here is the complete usage, copy and paste ready. Press CTRL + C to stop the program.'
	einfo 'while true; do echo "^BOh ^Mhello ^Ydear";sleep 1;done | /usr/bin/pinky-curses'
}
