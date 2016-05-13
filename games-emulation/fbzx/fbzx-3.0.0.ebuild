# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A Sinclair Spectrum emulator, designed to work at full screen using the FrameBuffer"
HOMEPAGE="https://github.com/rastersoft/fbzx"
SRC_URI="https://github.com/rastersoft/fbzx/archive/3.0.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]
	media-sound/pulseaudio
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s|/usr/share/|${GAMES_DATADIR}/${PN}/|g" src/llscreen.cpp || die
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dogamesbin src/fbzx
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/{keymap.bmp,spectrum-roms}
	dodoc AMSTRAD CAPABILITIES FAQ PORTING README* TODO VERSIONS
	doicon data/fbzx.svg
	make_desktop_entry fbzx FBZX
	prepgamesdirs
}
