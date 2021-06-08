# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

MY_FULL_PV=1.9.3
MY_PN="${PN/-bin/}"
DESCRIPTION="Quakeworld client with mqwcl functionality and many more features"
HOMEPAGE="http://ezquake.sf.net/"
SRC_URI="
	amd64? ( mirror://sourceforge/${MY_PN}/${MY_PN}_linux-x86_64.${MY_FULL_PV}.tar.gz
		mirror://sourceforge/${MY_PN}/${MY_PN}_linux64_${PV}.tar.gz )
	x86? ( mirror://sourceforge/${MY_PN}/${MY_PN}_linux-x86_${MY_FULL_PV}.tar.gz
		mirror://sourceforge/${MY_PN}/${MY_PN}_linux32_${PV}.tar.gz )
"
S="${WORKDIR}"/${MY_PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="cdinstall"

RESTRICT="strip mirror"

DEPEND="cdinstall? ( games-fps/quake1-data )"
RDEPEND="
	${DEPEND}
	virtual/opengl
	x11-libs/libXpm
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
"

MY_DIR=opt/${PN}
QA_PREBUILT="${MY_DIR}/ezquake*"

src_unpack() {
	unpack ${A}

	if use amd64; then
		mv ${MY_PN}_linux-x86_64.${MY_FULL_PV} "${MY_PN}" || die
		mv ezquake-gl_linux-x64.glx "${MY_PN}"/ezquake-gl.glx || die
	else
		mv ${MY_PN}_linux-x86.${MY_FULL_PV} "${MY_PN}" || die
		mv ezquake-gl_linux-x86.glx "${MY_PN}"/ezquake-gl.glx || die
	fi
}

src_install() {
	exeinto ${MY_DIR}
	insinto ${MY_DIR}

	doexe ezquake-gl.glx
	doins -r ezquake qw
	dosym ../../usr/share/quake1/id1 ${MY_DIR}/id1
	make_wrapper ezquake-gl.glx ./ezquake-gl.glx "${MY_DIR}" "${MY_DIR}"
}

pkg_postinst() {
	if ! use cdinstall; then
		elog "NOTE that this client doesn't include .pak files. You *should*"
		elog "enable \"cdinstall\" flag or install quake1-demodata with the symlink use flag."
		elog "You can also copy the files from your Quake1 CD to"
		elog "  ${MY_DIR}/quake1/id1 (all names lowercase)"
		elog ""
		elog "You may also want to check:"
		elog " http://fuhquake.quakeworld.nu - complete howto on commands and variables"
		elog " http://equake.quakeworld.nu - free package containing various files"
	fi
}
