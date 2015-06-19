# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-demo/quake3-demo-1.11-r1.ebuild,v 1.4 2015/06/14 19:49:39 ulm Exp $

EAPI=5
inherit eutils unpacker games

DESCRIPTION="the playable demo of Quake III Arena by Id Software"
HOMEPAGE="http://www.idsoftware.com/games/quake/quake3-arena/"
SRC_URI="mirror://idsoftware/quake3/linux/linuxq3ademo-${PV}-6.x86.gz.sh
	mirror://3dgamers/quake3arena/linuxq3ademo-${PV}-6.x86.gz.sh"

LICENSE="Q3AEULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="dedicated"
RESTRICT="strip"

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	dedicated? ( app-misc/screen )
	!dedicated? (
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	)"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/q3ded.x86
	${dir:1}/q3demo.x86"

src_unpack() {
	unpack_makeself
}

src_install() {
	insinto "${dir}"
	doins -r Help demoq3
	doins README icon.*

	exeinto "${dir}"
	newexe bin/x86/glibc-2.0/q3ded q3ded.x86
	games_make_wrapper q3ded ./q3ded.x86 "${dir}" "${dir}"
	if ! use dedicated; then
		newexe bin/x86/glibc-2.0/q3demo q3demo.x86
		games_make_wrapper q3demo ./q3demo.x86 "${dir}" "${dir}"
		make_desktop_entry q3demo "Quake III (Demo)"
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use dedicated; then
	elog "To play the game run:"
	elog " q3demo"
	fi
	echo
	elog "To start the gameserver, run:"
	elog " q3ded"
}
