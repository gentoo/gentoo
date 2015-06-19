# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/nestopia/nestopia-1.40.ebuild,v 1.10 2015/01/17 16:39:55 tupone Exp $

EAPI=5
inherit eutils flag-o-matic games

MY_PV="${PV//./}"
LNX_P="nst${MY_PV}_lnx_release_h"
DESCRIPTION="NEStopia is a portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://rbelmont.mameworld.info/?page_id=200"
SRC_URI="mirror://sourceforge/${PN}/Nestopia${MY_PV}src.zip
	http://rbelmont.mameworld.info/${LNX_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2
	media-libs/alsa-lib
	>=media-libs/libsdl-1.2.12[sound,joystick,video]
	sys-libs/zlib
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	sed \
	    -e "s:%GAMES_DATADIR%:${GAMES_DATADIR}:g" \
	    "${FILESDIR}"/${PN} \
	    > ${PN} \
	    || die "sed failed"
	strip-flags
}

src_install() {
	newgamesbin nst ${PN}.bin
	dogamesbin ${PN}

	insinto "${GAMES_DATADIR}/${PN}"
	doins NstDatabase.xml nstcontrols

	make_desktop_entry "${PN}" "Nestopia"

	dodoc README.Linux changelog.txt
	dohtml -r readme.html doc/*.html doc/details

	prepgamesdirs
}
