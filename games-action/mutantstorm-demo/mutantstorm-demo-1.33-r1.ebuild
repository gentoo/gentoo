# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils unpacker

DESCRIPTION="shoot through crazy psychedelic 3D environments"
HOMEPAGE="http://www.pompomgames.com/"
SRC_URI="ftp://ggdev-1.homelan.com/mutantstorm/MutantStormDemo_${PV/./_}.sh.bin"

LICENSE="POMPOM"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror bindist"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	sys-libs/lib-compat
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir=/opt/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/mutantstorm-bin"

src_install() {
	insinto "${dir}"
	doins -r menu script styles

	exeinto "${dir}"
	doexe bin/Linux/x86/*
	# Remove libSDL since we use the system version and our version doesn't
	# have TEXTRELs in it.
	rm -f "${Ddir}"/libSDL-1.2.so.0.0.5
	make_wrapper mutantstorm-demo ./mutantstormdemo "${dir}" "${dir}"

	insinto "${dir}"
	doins README.txt buy_me mutant.xpm pompom readme.htm
}
