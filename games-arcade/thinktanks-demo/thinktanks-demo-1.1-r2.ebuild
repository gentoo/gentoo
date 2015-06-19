# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/thinktanks-demo/thinktanks-demo-1.1-r2.ebuild,v 1.4 2015/06/01 21:38:20 mr_bones_ Exp $

EAPI=5
inherit unpacker games

DESCRIPTION="tank combat game with lighthearted, fast paced pandemonium"
HOMEPAGE="http://www.garagegames.com/pg/product/view.php?id=12"
SRC_URI="ftp://ggdev-1.homelan.com/thinktanks/ThinkTanksDemo_v${PV}.sh.bin"

LICENSE="THINKTANKS"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND="
	media-libs/libsdl[video,joystick,abi_x86_32(-)]
	media-libs/libogg[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_PREBUILT="${dir:1}/ThinkTanks.bin"

src_install() {
	dodir "${dir}" "${GAMES_BINDIR}"

	tar -zxf ThinkTanks.tar.gz -C "${ED}/${dir}" || die

	exeinto "${dir}"
	doexe bin/Linux/x86/thinktanksdemo
	dosym "${dir}"/thinktanksdemo "${GAMES_BINDIR}"/thinktanks-demo
	# Using system libraries
	rm -rf "${ED}/${dir}"/lib

	insinto "${dir}"
	doins icon.xpm

	dodoc ReadMe_Linux.txt

	prepgamesdirs
}
