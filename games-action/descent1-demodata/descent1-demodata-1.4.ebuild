# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

MY_PV=${PV/./}
DEMO="desc${MY_PV}sw.exe"

DESCRIPTION="Demo data files for Descent 1"
HOMEPAGE="http://en.wikipedia.org/wiki/Descent_%28computer_game%29"
SRC_URI="http://icculus.org/d2x/data/${DEMO}
	mirror://3dgamers/descent/${DEMO}
	ftp://ftp.funet.fi/pub/msdos/games/interplay/${DEMO}"

# See readme.txt
LICENSE="free-noncomm"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip
	app-arch/unarj"

S=${WORKDIR}

src_unpack() {
	unpack_zip ${A}

	unarj e DESCENT1.SOW || die
	mv descent.pig{,1}
	unarj e DESCENT2.SOW || die
	mv descent.pig{,2}

	# From the sows, big porkie pies shall grow
	cat descent.pig{1,2} > descent.pig || die

	rm *{1,2} *.{bat,exe,EXE,SOW,ubn}
}

src_install() {
	local dir=${GAMES_DATADIR}/d1x

	insinto "${dir}"
	doins descent.*

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "A client is needed to run the game, e.g. d1x-rebirth."
	elog "Not all Descent 1 clients support the demo data."
	echo
}
