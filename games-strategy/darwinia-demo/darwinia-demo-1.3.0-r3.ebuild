# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop unpacker wrapper

DESCRIPTION="Darwinia, the hyped indie game of the year. By the Uplink creators"
HOMEPAGE="http://www.darwinia.co.uk/downloads/demo_linux.html"
SRC_URI="http://www.introversion.co.uk/darwinia/downloads/${PN}2-${PV}.sh"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror strip"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir="/opt/${PN}"

src_unpack() {
	unpack_makeself
}

src_install() {
	exeinto "${dir}/lib"
	insinto "${dir}/lib"

	doexe lib/{darwinia.bin.x86,open-www.sh}
	doins lib/{sounds,main,language}.dat

	insinto "${dir}"
	doins README

	exeinto "${dir}"
	doexe bin/Linux/x86/darwinia

	make_wrapper darwinia-demo ./darwinia "${dir}" "${dir}"
	newicon darwinian.png ${PN}.png
	make_desktop_entry darwinia-demo "Darwinia (Demo)"
}
