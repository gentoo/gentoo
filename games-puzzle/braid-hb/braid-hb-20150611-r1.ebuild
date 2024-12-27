# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

MY_PN="braid"
DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="https://www.humblebundle.com/store/braid"
SRC_URI="BraidSetup-${PV:0:4}-${PV:4:2}-${PV:6:2}.sh"
S="${WORKDIR}/data"

LICENSE="all-rights-reserved Arphic CC-BY-NC-SA-1.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="launcher"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	!${CATEGORY}/${MY_PN}-gog
	media-gfx/nvidia-cg-toolkit[abi_x86_32]
	media-libs/libsdl2[joystick,opengl,sound,video,abi_x86_32]
	virtual/opengl[abi_x86_32]
	launcher? (
		media-libs/fontconfig:1.0[abi_x86_32]
		x11-libs/libX11[abi_x86_32]
		x11-libs/libXcursor[abi_x86_32]
		x11-libs/libXext[abi_x86_32]
		x11-libs/libXfixes[abi_x86_32]
		x11-libs/libXft[abi_x86_32]
		x11-libs/libXinerama[abi_x86_32]
	)
"

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

	doexe x86/Braid.bin.x86
	doins -r noarch/{data,Icon.bmp}
	dodoc noarch/READ_ME.txt

	if use launcher; then
		doexe x86/launcher.bin.x86
		exeinto "${DIR}"/lib
		doexe x86/lib/libfltk.so.1.3
		dosym "../..${DIR}/launcher.bin.x86" /usr/bin/${MY_PN}
	else
		dosym "../..${DIR}/Braid.bin.x86" /usr/bin/${MY_PN}
	fi

	newicon -s 256 noarch/Icon.png ${MY_PN}.png
	make_desktop_entry ${MY_PN} Braid
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use launcher; then
		elog "You have disabled the launcher. The game will run fullscreen with"
		elog "Vsync and postprocessing enabled at an optimal framerate by default."
		elog "Pass these options to change that:"
		elog ""
		elog "  -windowed -width [X] -height [Y] -no_vsync -no_post -[R]fps"
	fi
}
