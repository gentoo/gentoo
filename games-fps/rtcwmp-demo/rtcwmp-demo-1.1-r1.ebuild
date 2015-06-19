# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/rtcwmp-demo/rtcwmp-demo-1.1-r1.ebuild,v 1.4 2015/06/14 19:53:04 ulm Exp $

EAPI=5
inherit eutils unpacker games

MY_P="wolfmpdemo-linux-${PV}-MP.x86.run"

DESCRIPTION="Return to Castle Wolfenstein - Multi-player demo"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="mirror://idsoftware/wolf/linux/old/${MY_P}
	mirror://3dgamers/returnwolfenstein/${MY_P}"

LICENSE="RTCW GPL-2" # gpl for init script bug #425946
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="dedicated"
RESTRICT="strip mirror"

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	dedicated? ( app-misc/screen )
	!dedicated? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
	)"

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/{PN}/*
	${GAMES_PREFIX_OPT:1}/{PN}/demomain/*"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_install() {
	insinto "${dir}"
	doins -r demomain Docs
	doins WolfMP.xpm
	dodoc CHANGES QUICKSTART

	exeinto "${dir}"
	doexe bin/x86/wolfded.x86 openurl.sh
	games_make_wrapper rtcwmp-demo-ded ./wolfded.x86 "${dir}" "${dir}"
	newinitd "${FILESDIR}"/rtcwmp-demo-ded.rc rtcwmp-demo-ded
	sed "s:GENTOO_DIR:${dir}:" "${ED}"/etc/init.d/rtcwmp-demo-ded || die

	if ! use dedicated; then
		doexe bin/x86/wolf.x86
		games_make_wrapper rtcwmp-demo ./wolf.x86 "${dir}" "${dir}"
		newicon WolfMP.xpm rtcwmp-demo.xpm
		make_desktop_entry rtcwmp-demo "Return to Castle Wolfenstein (MP demo)" \
			rtcwmp-demo.xpm
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Install 'rtcwsp-demo' for single-player"
	elog
	if ! use dedicated; then
		elog "Run 'rtcwmp-demo' for multi-player"
		elog
	fi
	elog "Start a dedicated server with"
	elog "'/etc/init.d/rtcwmp-demo-ded start'"
	elog
	elog "Start the server at boot with"
	elog "'rc-update add rtcwmp-demo-ded default'"
}
