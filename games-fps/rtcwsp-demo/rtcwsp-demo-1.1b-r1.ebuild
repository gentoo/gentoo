# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

MY_P="wolfspdemo-linux-${PV}.x86.run"

DESCRIPTION="Return to Castle Wolfenstein - Single-player demo"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="mirror://idsoftware/wolf/linux/old/${MY_P}
	mirror://3dgamers/returnwolfenstein/${MY_P}"

LICENSE="RTCW"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip mirror"

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_install() {
	insinto "${dir}"
	doins -r demomain Docs

	exeinto "${dir}"
	doexe bin/x86/wolfsp.x86 openurl.sh || die "copying exe"

	games_make_wrapper ${PN} ./wolfsp.x86 "${dir}" "${dir}"

	# fix buffer overflow
	sed -i -e '/^exec/i \
export MESA_EXTENSION_MAX_YEAR=2003 \
export __GL_ExtensionStringVersion=17700' "${ED}/${GAMES_BINDIR}"/${PN}

	doins WolfSP.xpm CHANGES
	newicon WolfSP.xpm ${PN}.xpm

	prepgamesdirs
	make_desktop_entry ${PN} "Return to Castle Wolfenstein (SP demo)" \
		${PN}.xpm
}

pkg_postinst() {
	games_pkg_postinst
	elog "Install 'rtcwmp-demo' for multi-player"
	elog
	elog "Run '${PN}' for single-player"
}
