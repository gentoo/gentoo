# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3/doom3-1.3.1304-r1.ebuild,v 1.4 2015/06/14 17:27:57 ulm Exp $

EAPI=5
inherit eutils unpacker games

MY_PV="1.3.1.1304"

DESCRIPTION="3rd installment of the classic iD 3D first-person shooter"
HOMEPAGE="http://www.doom3.com/"
SRC_URI="mirror://idsoftware/doom3/linux/doom3-linux-${MY_PV}.x86.run
	http://zerowing.idsoftware.com/linux/${PN}.png"

LICENSE="DOOM3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall dedicated roe"
RESTRICT="strip"

DEPEND="app-arch/bzip2
	app-arch/tar"
RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	!dedicated? (
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
	)
	cdinstall? (
		>=games-fps/doom3-data-1.1.1282-r1
		roe? ( games-fps/doom3-roe ) )"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_TEXTRELS="${dir:1}/pb/pbcl.so
	${dir:1}/pb/pbcls.so
	${dir:1}/pb/pbag.so
	${dir:1}/pb/pbsv.so
	${dir:1}/pb/pbags.so"

QA_EXECSTACK="${dir:1}/doom.x86
	${dir:1}/doomded.x86"

pkg_pretend() {
	if use dedicated; then
		ewarn "${CATEGORY}/${PN}[dedicated] will only install the dedicated game server"
	fi
}

src_unpack() {
	unpack_makeself ${PN}-linux-${MY_PV}.x86.run
}

src_install() {
	insinto "${dir}"
	doins License.txt CHANGES README version.info ${PN}.png
	doins -r base d3xp pb

	exeinto "${dir}"
	doexe openurl.sh bin/Linux/x86/doomded.x86
	if ! use dedicated; then
		doexe bin/Linux/x86/doom.x86

		games_make_wrapper ${PN} ./doom.x86 "${dir}" "${dir}"
		doicon "${DISTDIR}"/${PN}.png || die "doicon"
		make_desktop_entry ${PN} "Doom III"
	fi
	games_make_wrapper ${PN}-ded ./doomded.x86 "${dir}" "${dir}"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use cdinstall; then
		elog "You need to copy pak000.pk4, pak001.pk4, pak002.pk4, pak003.pk4, and"
		elog "pak004.pk4 from either your installation media or your hard drive to"
		elog "${dir}/base before running the game,"
		elog "or 'emerge games-fps/doom3-data' to install from CD."
		if use roe ; then
			echo
			elog "To use the Resurrection of Evil expansion pack, you also need to copy"
			elog "pak000.pk4 to ${dir}/d3xp from the RoE CD before running the game,"
			elog "or 'emerge doom3-roe' to install from CD."
		fi
	fi

	if ! use dedicated; then
	echo
	elog "To play the game, run:"
	elog " doom3"
	fi
	echo
	elog "To start the dedicated server, run:"
	elog " doom3-ded"
}
