# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/darwinia-demo/darwinia-demo-1.3.0.ebuild,v 1.15 2015/06/01 20:50:01 mr_bones_ Exp $

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Darwinia, the hyped indie game of the year. By the Uplink creators"
HOMEPAGE="http://www.darwinia.co.uk/downloads/demo_linux.html"
SRC_URI="http://www.introversion.co.uk/darwinia/downloads/${PN}2-${PV}.sh"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="
	~virtual/libstdc++-3.3
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}

src_unpack() {
	unpack_makeself
}

src_install() {
	exeinto "${dir}/lib"
	insinto "${dir}/lib"

	doexe lib/{darwinia.bin.x86,open-www.sh}
	doins lib/{sounds,main,language}.dat

	insinto "${dir}"
	dodoc README

	exeinto "${dir}"
	doexe bin/Linux/x86/darwinia

	games_make_wrapper darwinia-demo ./darwinia "${dir}" "${dir}"
	newicon darwinian.png ${PN}.png
	make_desktop_entry darwinia-demo "Darwinia (Demo)"
	prepgamesdirs
}
