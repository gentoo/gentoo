# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ezquake-bin/ezquake-bin-2.2.ebuild,v 1.2 2014/08/10 21:21:26 slyfox Exp $

EAPI=5
inherit games

MY_FULL_PV=1.9.3
MY_PN="${PN/-bin/}"
DESCRIPTION="Quakeworld client with mqwcl functionality and many more features"
HOMEPAGE="http://ezquake.sf.net/"
SRC_URI="
	amd64? ( mirror://sourceforge/${MY_PN}/${MY_PN}_linux-x86_64.${MY_FULL_PV}.tar.gz
		mirror://sourceforge/${MY_PN}/${MY_PN}_linux64_${PV}.tar.gz )
	x86? ( mirror://sourceforge/${MY_PN}/${MY_PN}_linux-x86_${MY_FULL_PV}.tar.gz
		mirror://sourceforge/${MY_PN}/${MY_PN}_linux32_${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror"
IUSE="cdinstall"

DEPEND="cdinstall? ( games-fps/quake1-data )"
RDEPEND="${DEPEND}
		virtual/opengl
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm"

S=${WORKDIR}/${MY_PN}

dir=${GAMES_PREFIX_OPT}/${PN}

QA_PREBUILT="${dir:1}/ezquake*"

src_unpack() {
	unpack ${A}
	if use amd64; then
		mv ${MY_PN}_linux-x86_64.${MY_FULL_PV} "${MY_PN}"
		mv ezquake-gl_linux-x64.glx "${MY_PN}"/ezquake-gl.glx
	else
		mv ${MY_PN}_linux-x86.${MY_FULL_PV} "${MY_PN}"
		mv ezquake-gl_linux-x86.glx "${MY_PN}"/ezquake-gl.glx
	fi
}

src_install() {
	exeinto "${dir}"
	insinto "${dir}"

	doexe ezquake-gl.glx
	doins -r ezquake qw
	dosym "${GAMES_DATADIR}"/quake1/id1 "${dir}"/id1
	games_make_wrapper ezquake-gl.glx ./ezquake-gl.glx "${dir}" "${dir}"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use cdinstall; then
		elog "NOTE that this client doesn't include .pak files. You *should*"
		elog "enable \"cdinstall\" flag or install quake1-demodata with the symlink use flag."
		elog "You can also copy the files from your Quake1 CD to"
		elog "  ${dir}/quake1/id1 (all names lowercase)"
		elog ""
		elog "You may also want to check:"
		elog " http://fuhquake.quakeworld.nu - complete howto on commands and variables"
		elog " http://equake.quakeworld.nu - free package containing various files"
	fi
}
