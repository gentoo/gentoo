# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

MY_P="${P/-/_}"

DESCRIPTION="The world's first genocide 'em up"
HOMEPAGE="https://www.introversion.co.uk/defcon/"
SRC_URI="
	amd64? ( https://www.introversion.co.uk/${PN}/downloads/${MY_P}-1_amd64.deb )
	x86? ( https://www.introversion.co.uk/${PN}/downloads/${MY_P}-1_i386.deb )
"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	media-libs/libogg
	media-libs/libsdl
	media-libs/libvorbis
	virtual/glu
"

RESTRICT="bindist mirror strip"

S="${WORKDIR}/usr/local/games/${PN}"

QA_PREBUILT="
	opt/defcon/defcon.bin.x86
	opt/defcon/defcon.bin.x86_64
"

src_unpack() {
	unpack_deb ${A}
}

src_compile() {
	:;
}

src_install() {
	exeinto /opt/defcon
	doexe defcon.bin.x86$(usex amd64 '_64' '')

	insinto /opt/defcon
	doins *.dat

	dodir /opt/bin
	dosym ../defcon/defcon.bin.x86$(usex amd64 '_64' '') /opt/bin/defcon

	doicon defcon.png

	make_desktop_entry "defcon" "Defcon" defcon Game

	dodoc linux.txt
}
