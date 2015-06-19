# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/fbzx/fbzx-2.10.0.ebuild,v 1.5 2015/01/17 15:44:15 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A Sinclair Spectrum emulator, designed to work at full screen using the FrameBuffer"
HOMEPAGE="http://www.rastersoft.com/fbzx.html"
SRC_URI="http://www.rastersoft.com/descargas/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]
	media-sound/pulseaudio
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s|/usr/share/|${GAMES_DATADIR}/${PN}/|g" emulator.c || die
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-keyboard.patch
}

src_install() {
	dogamesbin fbzx
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r keymap.bmp spectrum-roms
	dodoc AMSTRAD CAPABILITIES FAQ PORTING README* TODO VERSIONS
	doicon fbzx.svg
	make_desktop_entry fbzx FBZX
	prepgamesdirs
}
