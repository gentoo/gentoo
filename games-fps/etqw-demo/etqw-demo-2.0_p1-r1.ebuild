# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/etqw-demo/etqw-demo-2.0_p1-r1.ebuild,v 1.3 2015/06/14 16:59:55 ulm Exp $

EAPI=5
inherit unpacker eutils versionator games

MY_MAJOR=$(get_major_version)
MY_REV=$(get_version_component_range 3)
MY_BODY="ETQW-demo${MY_MAJOR}-client-full.r${MY_REV/p/}.x86"

DESCRIPTION="Enemy Territory: Quake Wars demo"
HOMEPAGE="http://zerowing.idsoftware.com/linux/etqw/"
SRC_URI="mirror://idsoftware/etqw/${MY_BODY}.run"

# See copyrights.txt
LICENSE="ETQW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND="app-arch/unzip"
RDEPEND=">=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
	>=virtual/jpeg-62:62[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r4[video,sound,opengl,abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_PREBUILT="${dir:1}/guis/libmojosetupgui_ncurses.so
	${dir:1}/data/*
	${dir:1}/data/pb/*.so"

src_unpack() {
	# exit status of 1 should just be warnings, not corrupt archive
	unpack_zip ${A}
}

src_install() {
	insinto "${dir}"
	doins -r guis scripts

	cd data
	insinto "${dir}"/data
	doins -r base pb etqw_icon.png
	dodoc README.txt EULA.txt copyrights.txt etqwtv.txt

	exeinto "${dir}"/data
	doexe etqw *\.x86 etqw-* libCgx86* libSDL* *.sh

	games_make_wrapper ${PN} ./etqw.x86 "${dir}"/data "${dir}"/data
	# Matches with desktop entry for enemy-territory-truecombat
	make_desktop_entry ${PN} "Enemy Territory - Quake Wars (Demo)"

	games_make_wrapper ${PN}-ded ./etqwded.x86 "${dir}"/data "${dir}"/data

	prepgamesdirs
}
