# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Control your own kingdom in this simulation"
HOMEPAGE="http://www.linuxgamepublishing.com/info.php?id=8&"
SRC_URI="http://ftp2.za.freebsd.org/pub/FreeBSD/ports/distfiles/majesty_demo.run"

LICENSE="MAJESTY-DEMO"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="bindist strip"

RDEPEND="sys-libs/glibc
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/maj_demo"

src_install() {
	dodoc README*
	insinto "${dir}"
	exeinto "${dir}"
	doins -r data quests
	doins majesty.{bmp,xpm} majestysite.url
	newicon majesty.xpm majesty-demo.xpm
	# only installing the static version for now
	if use x86 || use amd64; then
		doexe bin/Linux/x86/maj_demo
	fi
	games_make_wrapper maj_demo ./maj_demo "${dir}" "${dir}"
	prepgamesdirs
	make_desktop_entry maj_demo "Majesty (Demo)"
}
