# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-/_}

inherit desktop

DESCRIPTION="High tech computer crime and corporate espionage simulator"
HOMEPAGE="https://www.introversion.co.uk/uplink/"
SRC_URI="
	amd64? ( "${MY_P}-1_amd64.tar.gz" )
	x86? ( "${MY_P}-1_i386.tar.gz" )
"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	media-libs/freetype
	media-libs/libmikmod
	media-libs/libjpeg-turbo
	media-libs/sdl-mixer
	virtual/glu
"

RESTRICT="bindist fetch mirror strip"

S="${WORKDIR}/${PN}"

QA_PREBUILT="
	opt/uplink/uplink.bin.x86
	opt/uplink/uplink.bin.x86_64
	opt/uplink/lib/*.so*
	opt/uplink/lib64/*.so*
"

src_unpack() {
	default

	mv uplink-* uplink || die
}

src_compile() {
	:;
}

src_install() {
	exeinto /opt/uplink
	doexe uplink.bin.x86$(usex amd64 '_64' '')

	insinto /opt/uplink
	doins *.dat

	# Uplink crashes, when newer compiled libSDL is used.
	# It also depends on older libmikmod and libtiff.
	exeinto /opt/uplink/lib$(usex amd64 '64' '')
	doexe lib$(usex amd64 '64' '')/{libmikmod.so.2,libSDL-1.2.so.0,libSDL_mixer-1.2.so.0,libtiff.so.3}

	dodir /opt/bin
	dosym ../uplink/uplink.bin.x86$(usex amd64 '_64' '') /opt/bin/uplink

	doicon uplink.png

	make_desktop_entry "uplink" "Uplink" uplink Game

	dodoc {changes,mods,readme}.txt
}
