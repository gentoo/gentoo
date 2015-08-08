# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Hardware mouse cursors for Neverwinter Nights"
HOMEPAGE="http://home.roadrunner.com/~nwmovies/"
SRC_URI="http://dev.gentoo.org/~calchan/distfiles/${P}.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="nwmovies Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND="
	>=games-rpg/nwn-1.68-r4
	games-rpg/nwn-data
	sys-libs/glibc
	>=dev-libs/elfutils-0.155-r1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]"

# I've looked at this stuff, and I can't find the problem myself, so I'm just
# removing the warnings.  If someone feels like finding the patch, that would be
# great and I'll gladly include it.
dir="${GAMES_PREFIX_OPT}/nwn"
QA_PREBUILT="${dir:1}/nwmouse.so
	${dir:1}/nwmouse/libdis/libdisasm.so"

src_install() {
	# libelf moved to games-rpg/nwn, see bug #210562
	exeinto "${dir}"
	doexe "${PN}.so"
	exeinto "${dir}/${PN}/libdis"
	doexe "libdisasm.so"
	insinto "${dir}/${PN}/cursors"
	doins -r cursors/*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "When starting nwn the next time, nwmouse will scan the nwmain"
	elog "binary for its hooks, store this information in:"
	elog "  ${dir}/nwmouse.ini"
	elog "and exit. This is normal."
	elog
	elog "You will have to remove this file whenever you update nwn."
}
