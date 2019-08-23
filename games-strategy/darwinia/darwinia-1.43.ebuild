# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_P="${P/-/_}"

DESCRIPTION="A digital dreamscape simulation game"
HOMEPAGE="https://www.introversion.co.uk/darwinia/"
SRC_URI="
	amd64? ( ${MY_P}_amd64.tar.gz )
	x86? ( ${MY_P}_i386.tar.gz )
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

RESTRICT="bindist fetch mirror strip"

S="${WORKDIR}/${PN}"

QA_PREBUILT="
	opt/darwinia/darwinia.bin.x86
	opt/darwinia/darwinia.bin.x86_64
"

src_unpack() {
	default

	if use x86; then
		mv Darwinia darwinia || die
	fi
}

src_compile() {
	:;
}

src_install() {
	exeinto /opt/darwinia
	doexe darwinia.bin.x86$(usex amd64 '_64' '')

	insinto /opt/darwinia
	doins *.dat

	dodir /opt/bin
	dosym ../darwinia/darwinia.bin.x86$(usex amd64 '_64' '') /opt/bin/darwinia

	doicon darwinian.png

	make_desktop_entry "darwinia" "Darwinia" darwinian Game

	dodoc {changes,readme-linux}.txt
}
