# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

MY_P="${P/-/_}"
MY_PN="${PN/m/M}"

DESCRIPTION="The ultimate retro-arcade multiplayer experience"
HOMEPAGE="https://www.introversion.co.uk/multiwinia/"
SRC_URI="
	amd64? ( https://www.introversion.co.uk/${PN}/downloads/${MY_PN}-${PV}-linux/${MY_P}-1_amd64.deb )
	x86? ( https://www.introversion.co.uk/${PN}/downloads/${MY_PN}-${PV}-linux/${MY_P}-1_i386.deb )
"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	media-libs/libogg
	media-libs/libpng-compat:1.2
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
"

RESTRICT="bindist mirror strip"

S="${WORKDIR}/usr/local/games/${PN}"

QA_PREBUILT="
	opt/multiwinia/multiwinia.bin.x86
	opt/multiwinia/multiwinia.bin.x86_64
"

src_unpack() {
	unpack_deb ${A}
}

src_compile() {
	:;
}

src_install() {
	exeinto /opt/multiwinia
	doexe multiwinia.bin.x86$(usex amd64 '_64' '')

	insinto /opt/multiwinia
	doins *.dat

	dodir /opt/bin
	dosym ../multiwinia/multiwinia.bin.x86$(usex amd64 '_64' '') /opt/bin/multiwinia

	doicon multiwinia.png

	make_desktop_entry "multiwinia" "Multiwinia" multiwinia Game

	dodoc docs/{manual.pdf,readme.txt}
}
