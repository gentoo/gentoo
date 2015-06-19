# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/coldwar-demo/coldwar-demo-1-r2.ebuild,v 1.3 2015/06/01 20:52:07 mr_bones_ Exp $

EAPI=5
inherit eutils unpacker games

MY_PN=${PN%-demo}

DESCRIPTION="Third-person sneaker like Splinter Cell"
HOMEPAGE="http://linuxgamepublishing.com/info.php?id=coldwar"
SRC_URI="http://demofiles.linuxgamepublishing.com/coldwar/coldwar-demo.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist strip"

RDEPEND="
	>=dev-libs/glib-2.34.3[abi_x86_32(-)]
	>=media-libs/libogg-1.3.0[abi_x86_32(-)]
	>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]
	>=media-libs/smpeg-0.4.4-r10[abi_x86_32(-)]
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_PREBUILT="${dir:1}/lib/*
	${dir:1}/bin/meng"

src_unpack() {
	unpack_makeself
	unpack ./data/data.tar.gz

	mv bin/Linux/x86/${MY_PN}_demo .
	mv bin/Linux/x86/bin/meng bin

	rm -r bin/{Linux,*BSD} lgp_* setup.* data/data.tar.gz
}

src_install() {
	insinto "${dir}"
	doins -r *
	rm "${D}/${dir}"/{${MY_PN}_demo,bin/{launcher,meng}}

	exeinto "${dir}"
	doexe ${MY_PN}_demo
	exeinto "${dir}/bin"
	doexe bin/{launcher,meng}

	games_make_wrapper ${PN} ./${MY_PN}_demo "${dir}" "${dir}"
	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Cold War (Demo)" ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "The instruction manual is available as:"
	elog "   http://demofiles.linuxgamepublishing.com/coldwar/manual.pdf"
	echo
	einfo "To play the game, run: ${PN}"
}
