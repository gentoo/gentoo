# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/rtcw/rtcw-1.41b.ebuild,v 1.21 2015/06/14 19:51:56 ulm Exp $

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Return to Castle Wolfenstein - Long awaited sequel to Wolfenstein 3D"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="mirror://idsoftware/wolf/linux/wolf-linux-GOTY-maps.x86.run
	mirror://idsoftware/wolf/linux/wolf-linux-${PV}.x86.run"
#	mirror://3dgamers/returnwolfenstein/wolf-linux-${PV}.x86.run

LICENSE="RTCW GPL-2" # gpl for init script bug #425944
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl dedicated"
RESTRICT="strip mirror"

UIDEPEND="x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"
RDEPEND="sys-libs/glibc
	sys-libs/lib-compat
	dedicated? ( app-misc/screen )
	!dedicated? ( ${UIDEPEND} )
	opengl? ( ${UIDEPEND} )"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/* ${dir:1}/pb/* ${dir:1}/main/*"

src_install() {
	insinto "${dir}"
	doins -r main Docs pb

	exeinto "${dir}"
	doexe bin/Linux/x86/*.x86 openurl.sh

	games_make_wrapper rtcwmp ./wolf.x86 "${dir}" "${dir}"
	games_make_wrapper rtcwsp ./wolfsp.x86 "${dir}" "${dir}"
	# work around buggy video driver (bug #326837)
	sed -i \
		-e 's/^exec /__GL_ExtensionStringVersion=17700 exec /' \
		"${D}/${GAMES_BINDIR}/rtcwsp" \
		|| die

	if use dedicated; then
		games_make_wrapper wolf-ded ./wolfded.x86 "${dir}" "${dir}"
		newinitd "${FILESDIR}"/wolf-ded.rc wolf-ded
		sed -i \
			-e "s:GENTOO_DIR:${dir}:" \
			"${D}"/etc/init.d/wolf-ded \
			|| die
	fi

	insinto ${dir}
	doins WolfMP.xpm WolfSP.xpm QUICKSTART CHANGES RTCW-README-1.4.txt
	doicon WolfMP.xpm WolfSP.xpm

	prepgamesdirs
	make_desktop_entry rtcwmp "Return to Castle Wolfenstein (MP)" WolfMP
	make_desktop_entry rtcwsp "Return to Castle Wolfenstein (SP)" WolfSP
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "There are two possible security bugs in this package, both causing a"
	ewarn "denial of service.  One affects the game when running a server, the"
	ewarn "other when running as a client."
	ewarn "For more information, see bug #82149."
	echo
	elog "You need to copy pak0.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3,"
	elog "sp_pak1.pk3 and sp_pak2.pk3 from a Window installation into ${dir}/main/"
	elog
	elog "To play the game run:"
	elog " rtcwsp (single-player)"
	elog " rtcwmp (multi-player)"
	elog
	if use dedicated
	then
		elog "To start a dedicated server run:"
		elog " /etc/init.d/wolf-ded start"
		elog
		elog "To run the dedicated server at boot, type:"
		elog " rc-update add wolf-ded default"
		elog
		elog "The dedicated server is started under the ${GAMES_USER_DED} user account"
		echo
	fi
}
