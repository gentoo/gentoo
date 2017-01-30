# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils unpacker

MY_P="spacetripperdemo"
DESCRIPTION="Hardcore arcade shoot-em-up"
HOMEPAGE="http://www.pompomgames.com/"
SRC_URI="http://www.btinternet.com/~bongpig/${MY_P}.sh"

LICENSE="POMPOM"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-),X,video,joystick,opengl,sound]"

S=${WORKDIR}

dir=/opt/${PN}
Ddir=${D}/${dir}

QA_PREBUILT="${dir}/*"

src_unpack() {
	unpack_makeself
}

src_install() {
	exeinto "${dir}"
	doexe bin/x86/*
	# Remove libSDL since we use the system version and our version doesn't
	# have TEXTRELs in it.
	rm -f "${Ddir}"/libSDL-1.2.so.0.0.5 || die
	sed -i -e "s:XYZZY:${dir}:" "${Ddir}/${MY_P}" || die

	insinto "${dir}"
	doins -r preview run styles README license.txt icon.xpm
	newicon icon.xpm spacetripper-demo.png

	make_wrapper spacetripper-demo ./spacetripperdemo "${dir}" "${dir}"
	make_desktop_entry spacetripper-demo spacetripper-demo spacetripper-demo
}
