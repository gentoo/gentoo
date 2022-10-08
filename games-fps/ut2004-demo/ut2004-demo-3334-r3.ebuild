# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

MY_P="ut2004-lnx-demo${PV}.run"
DESCRIPTION="Demo for the critically-acclaimed first-person shooter"
HOMEPAGE="http://www.unrealtournament.com/"
SRC_URI="mirror://gentoo/${MY_P}"
S="${WORKDIR}"

LICENSE="ut2003-demo"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"

dir=/opt/${PN}
Ddir="${ED}"/${dir#/}
QA_PREBUILT="${dir#/}/System/*"

src_unpack() {
	unpack_makeself
	unpack ./setupstuff.tar.gz
}

src_install() {
	dodir ${dir}

	tar xjf ut2004demo.tar.bz2 -C "${Ddir}" || die

	if use x86 ; then
		tar xjf linux-x86.tar.bz2 || die
	elif use amd64 ; then
		tar xjf linux-amd64.tar.bz2 || die
	fi

	insinto ${dir}
	doins README.linux ut2004.xpm
	newicon ut2004.xpm ut2004-demo.xpm

	exeinto ${dir}
	doexe bin/ut2004-demo

	exeinto ${dir}/System
	doexe System/{libSDL-1.2.so.0,openal.so,ucc-bin,ut2004-bin}

	make_wrapper ut2004-demo ./ut2004-demo "${dir}" "${dir}"
	make_desktop_entry ut2004-demo "Unreal Tournament 2004 (Demo)" ut2004-demo
}

pkg_postinst() {
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
