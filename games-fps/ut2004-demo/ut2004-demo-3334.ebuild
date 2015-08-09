# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

MY_P="ut2004-lnx-demo${PV}.run"
DESCRIPTION="Demo for the critically-acclaimed first-person shooter"
HOMEPAGE="http://www.unrealtournament.com/"
SRC_URI="mirror://gentoo/${MY_P}"

LICENSE="ut2003-demo"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"
IUSE=""

DEPEND=""
RDEPEND="
	virtual/libstdc++:3.3
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/System/*"

src_unpack() {
	unpack_makeself
	unpack ./setupstuff.tar.gz
}

src_install() {
	dodir "${dir}"

	tar xjf ut2004demo.tar.bz2 -C "${Ddir}" || die

	if use x86
	then
		tar xjf linux-x86.tar.bz2 || die
	fi
	if use amd64
	then
		tar xjf linux-amd64.tar.bz2 || die
	fi

	insinto "${dir}"
	doins README.linux ut2004.xpm
	newicon ut2004.xpm ut2004-demo.xpm

	exeinto "${dir}"
	doexe bin/ut2004-demo

	exeinto "${dir}"/System
	doexe System/{libSDL-1.2.so.0,openal.so,ucc-bin,ut2004-bin}

	games_make_wrapper ut2004-demo ./ut2004-demo "${dir}" "${dir}"
	make_desktop_entry ut2004-demo "Unreal Tournament 2004 (Demo)" ut2004-demo

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "For Text To Speech:"
	elog "   1) emerge festival speechd"
	elog "   2) Edit your ~/.ut2004demo/System/UT2004.ini file."
	elog "      In the [SDLDrv.SDLClient] section, add:"
	elog "         TextToSpeechFile=/dev/speech"
	elog "   3) Start speechd."
	elog "   4) Start the game.  Be sure to go into the Audio"
	elog "      options and enable Text To Speech."
	echo
	elog "To test, pull down the console (~) and type:"
	elog "   TTS this is a test."
	echo
	elog "You should hear something that sounds like 'This is a test.'"
	echo
}
