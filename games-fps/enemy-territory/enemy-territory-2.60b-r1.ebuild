# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

DESCRIPTION="standalone multi-player game based on Return to Castle Wolfenstein"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="mirror://3dgamers/wolfensteinet/et-linux-2.60.x86.run
	mirror://idsoftware/et/linux/et-linux-2.60.x86.run
	ftp://ftp.red.telefonica-wholesale.net/GAMES/ET/linux/et-linux-2.60.x86.run
	mirror://idsoftware/et/ET-${PV}.zip
	dedicated? (
		https://dev.gentoo.org/~wolf31o2/sources/dump/${PN}-all-0.1.tar.bz2
		mirror://gentoo/${PN}-all-0.1.tar.bz2
	)"

LICENSE="RTCW-ETEULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="dedicated"
RESTRICT="mirror strip"

DEPEND="app-arch/unzip"
RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	dedicated? ( app-misc/screen )
	!dedicated? (
		virtual/opengl[abi_x86_32(-)]
		x11-libs/libX11[abi_x86_32(-)]
		x11-libs/libXext[abi_x86_32(-)]
	)"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

QA_PREBUILT="
	${dir:1}/et.x86
	${dir:1}/etmain/cgame.mp.i386.so
	${dir:1}/etmain/qagame.mp.i386.so
	${dir:1}/etmain/ui.mp.i386.so
	${dir:1}/pb/pbag.so
	${dir:1}/pb/pbags.so
	${dir:1}/pb/pbcl.so
	${dir:1}/pb/pbcls.so
	${dir:1}/pb/pbsv.so
	${dir:1}/pb/pbweb.x86"

src_unpack() {
	unpack_makeself et-linux-2.60.x86.run
	if use dedicated; then
		unpack ${PN}-all-0.1.tar.bz2
	fi
	unpack ET-${PV}.zip
}

src_install() {
	exeinto "${dir}"
	doexe openurl.sh

	insinto "${dir}"
	dodoc CHANGES README

	cp -r Docs pb etmain "${Ddir}" || die
	chmod og+x "${Ddir}"/pb/pbweb.x86 || die

	if ! use dedicated ; then
		doicon ET.xpm
		doexe "Enemy Territory 2.60b"/linux/et.x86
		games_make_wrapper et ./et.x86 "${dir}" "${dir}"
		make_desktop_entry et "Enemy Territory" ET
	else
		doexe "Enemy Territory 2.60b"/linux/etded.x86
		games_make_wrapper et-ded ./etded.x86 "${dir}"
		newinitd "${S}"/et-ded.rc et-ded
		sed -i \
			-e "s:GAMES_USER_DED:${GAMES_USER_DED}:" \
			-e "s:GENTOO_DIR:${GAMES_BINDIR}:" \
			"${D}"/etc/init.d/et-ded || die
		newconfd "${S}"/et-ded.conf.d et-ded
		# TODO: move this to /var/ perhaps ?
		keepdir "${dir}/etwolf-homedir"
		chmod g+rw "${Ddir}/etwolf-homedir"
		dosym "${dir}/etwolf-homedir" "${GAMES_PREFIX}/.etwolf"
	fi

	prepgamesdirs
	chmod g+rw "${Ddir}" "${Ddir}/etmain"
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "There are two possible security bugs in this package, both causing a"
	ewarn "denial of service.  One affects the game when running a server, the"
	ewarn "other when running as a client."
	ewarn "For more information, see bug #82149."
	echo
	if ! use dedicated; then
		elog "To play the game run:"
		elog " et"
		echo
	else
		elog "To start a dedicated server run:"
		elog " /etc/init.d/et-ded start"
		echo
		elog "To run the dedicated server at boot, type:"
		elog " rc-update add et-ded default"
		echo
		elog "The dedicated server is started under the ${GAMES_USER_DED} user account."
		echo
		ewarn "Store your configurations under ${dir}/etwolf-homedir or they"
		ewarn "will be erased on the next upgrade."
		ewarn "See bug #132795 for more info."
		echo
	fi
}
