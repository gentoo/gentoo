# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/kigb/kigb-2.02.ebuild,v 1.7 2015/03/30 18:52:44 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="A Gameboy (GB, SGB, GBA) Emulator for Linux"
HOMEPAGE="http://kigb.emuunlim.com/"
SRC_URI="http://kigb.emuunlim.com/${PN}_lin.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="mirror bindist strip"

RDEPEND="x11-libs/libXext
	sys-libs/zlib
	dev-games/hawknl
	=virtual/libstdc++-3*"

S=${WORKDIR}

src_prepare() {
	# use the system version
	rm -f libNL.so*
	# wrapper script creates these in the users' home directories.
	rm -rf cfg inp snap state rom save
	cp "${FILESDIR}/kigb" "${T}/" || die
	sed -i \
		-e "s:GENTOODIR:${GAMES_PREFIX_OPT}:" "${T}/kigb" || die
}

src_install() {
	dogamesbin "${T}/kigb"
	exeinto "${GAMES_PREFIX_OPT}/${PN}"
	doexe kigb
	dodoc doc/*
	prepgamesdirs
}
