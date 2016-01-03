# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

MY_PN=${PN/soldieroffortune/sof}

DESCRIPTION="First-person shooter based on the mercenary trade"
HOMEPAGE="http://www.lokigames.com/products/sof/"
SRC_URI="mirror://lokigames/loki_demos/${MY_PN}.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="games-util/loki_patch"
RDEPEND="virtual/opengl[abi_x86_32(-)]
	media-libs/libsdl[X,opengl,sound,abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	media-libs/smpeg[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/* ${dir:1}/base/*so"

src_install() {
	local demo="data/demos/sof_demo"
	local exe="sof-bin.x86"

	loki_patch patch.dat data/ || die

	insinto "${dir}"
	exeinto "${dir}"
	doins -r "${demo}"/*
	doexe "${demo}/${exe}"

	# Replace bad library
	dosym /usr/$(use amd64 && echo lib32 || echo lib)/libSDL.so "${dir}"/libSDL-1.1.so.0

	games_make_wrapper ${PN} "./${exe}" "${dir}" "${dir}"

	# fix buffer overflow
	sed -i \
		-e '/^exec/i \
export MESA_EXTENSION_MAX_YEAR=2003 \
export __GL_ExtensionStringVersion=17700' "${ED}"${GAMES_BINDIR}/${PN} || die

	newicon "${demo}"/launch/box.png ${PN}.png
	make_desktop_entry ${PN} "Soldier of Fortune (Demo)"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "This game requires OSS sound device /dev/dsp ; make sure the module"
	ewarn "snd_pcm_oss is loaded and/or built into your kernel or there will be no sound"
	elog
	elog "Run '${PN}' to start the game"
}
