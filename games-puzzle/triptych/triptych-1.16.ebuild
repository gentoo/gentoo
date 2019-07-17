# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="Fast-paced Tetris-like puzzler"
HOMEPAGE="http://www.chroniclogic.com/triptych.htm"
SRC_URI="http://www.chroniclogic.com/demos/${PN}.tar.gz"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="acct-group/gamestat
	>=media-libs/libsdl-1.2[abi_x86_32,opengl,sound,video]
	virtual/opengl[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXext[abi_x86_32]"

QA_PREBUILT="opt/${PN}/${PN}
	opt/${PN}/setup"

S="${WORKDIR}/${PN}"

DIR="/opt/${PN}"
WRITABLE=( "${EROOT}${DIR}"/{hwconfig.cfg,${PN}.{clr,cnt,scr}} )

src_prepare() {
	default
	rm -v *.dll || die
}

src_install() {
	local EXES=( ${PN} setup )

	insinto "${DIR}"
	doins -r .

	exeinto "${DIR}"
	doexe "${EXES[@]}"

	fowners root:gamestat "${EXES[@]/#/${DIR}/}" || die
	fperms g+s "${EXES[@]/#/${DIR}/}" || die

	make_wrapper ${PN} ./${PN} "${DIR}"
	make_wrapper ${PN}-setup ./setup "${DIR}"
}

pkg_postinst() {
	touch "${WRITABLE[@]}" || die
	chown root:gamestat "${WRITABLE[@]}" || die
	chmod 0664 "${WRITABLE[@]}" || die
}

pkg_prerm() {
	[[ -z ${REPLACED_BY_VERSION} ]] &&
		rm -v "${WRITABLE[@]}"
}
