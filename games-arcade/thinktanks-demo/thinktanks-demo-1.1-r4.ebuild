# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

DESCRIPTION="Tank combat game with lighthearted, fast paced pandemonium"
HOMEPAGE="http://www.garagegames.com/pg/product/view.php?id=12"
SRC_URI="http://demos.garagegames.com/thinktanks/ThinkTanksDemo_v${PV}.sh.bin"
S="${WORKDIR}"

LICENSE="THINKTANKS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	media-libs/libsdl[video,joystick,abi_x86_32(-)]
	media-libs/libogg[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
"

dir="/opt/${PN}"

QA_PREBUILT="${dir:1}/ThinkTanks.bin"

src_install() {
	dodir "${dir}" "/usr/bin"

	tar -zxf ThinkTanks.tar.gz -C "${ED}/${dir}" || die

	exeinto "${dir}"
	doexe bin/Linux/x86/thinktanksdemo
	dosym "${dir}"/thinktanksdemo /usr/bin/thinktanks-demo
	# Using system libraries
	rm -rf "${ED}/${dir}"/lib

	insinto "${dir}"
	doins icon.xpm

	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Thinktanks (Demo)" /usr/share/pixmaps/${PN}.xpm

	dodoc ReadMe_Linux.txt
}
