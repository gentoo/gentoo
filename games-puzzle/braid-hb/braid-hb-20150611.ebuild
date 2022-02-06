# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

MY_PN="braid"
DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="https://www.humblebundle.com/store/braid"
SRC_URI="BraidSetup-${PV:0:4}-${PV:4:2}-${PV:6:2}.sh"

LICENSE="all-rights-reserved Arphic CC-BY-NC-SA-1.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	media-gfx/nvidia-cg-toolkit[abi_x86_32]
	media-libs/libsdl2[joystick,opengl,sound,video,abi_x86_32]
	virtual/opengl[abi_x86_32]
	x11-libs/fltk:1[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	!${CATEGORY}/${MY_PN}-gog
"

S="${WORKDIR}/data"
DIR="/opt/${MY_PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${DIR}"
	insinto "${DIR}"

	doexe x86/{Braid,launcher}.bin.x86
	doins -r noarch/{data,Icon.*}
	dodoc noarch/READ_ME.txt

	make_wrapper ${MY_PN} ./launcher.bin.x86 "${DIR}" /usr/$(ABI=x86 get_libdir)/fltk
	make_desktop_entry ${MY_PN} Braid "${EPREFIX}${DIR}"/Icon.png
}
