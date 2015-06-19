# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/mindrover-demo/mindrover-demo-1.07b.ebuild,v 1.8 2014/07/16 00:36:31 mr_bones_ Exp $

EAPI=5
inherit eutils unpacker games

MY_P="mindrover_demo.run"
DESCRIPTION="Control a robot as it races across Europa"
HOMEPAGE="http://www.linuxgamepublishing.com/info.php?id=9"
SRC_URI=" http://demos.linuxgamepublishing.com/mindrover/${MY_P}"

LICENSE="all-rights-reserved GPL-2+"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="mirror bindist strip"

RDEPEND="virtual/opengl"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	dodir "${dir}"

	tar -zxf data.tar.gz -C "${Ddir}"/ || die
	tar -zxf music.tar.gz -C "${Ddir}"/ || die

	dodoc README
	newicon icon.xpm ${PN}.xpm || die
	exeinto "${dir}"
	doexe bin/Linux/x86/glibc-2.1/mindrover_demo \
		bin/Linux/x86/glibc-2.1/lib/libopenal.so.0.0.6 || die
	dosym "${dir}"/libopenal.so.0.0.6 "${dir}"/libopenal.so.0

	games_make_wrapper ${PN} ./mindrover_demo "${dir}" "${dir}"
	make_desktop_entry ${PN} "Mindrover: Europa Project (Demo)"

	prepgamesdirs
}
