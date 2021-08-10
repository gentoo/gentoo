# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

MY_MAJOR=$(ver_cut 1)
MY_REV=$(ver_cut 3-)
MY_BODY="ETQW-demo${MY_MAJOR}-client-full.r${MY_REV/p/}.x86"

DESCRIPTION="Enemy Territory: Quake Wars demo"
HOMEPAGE="http://zerowing.idsoftware.com/linux/etqw/"
SRC_URI="mirror://idsoftware/etqw/${MY_BODY}.run"
S="${WORKDIR}"

# See copyrights.txt
LICENSE="ETQW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist strip mirror"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[video,sound,opengl,abi_x86_32(-)]
	sys-libs/ncurses-compat[abi_x86_32(-)]
	>=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
	virtual/jpeg-compat:62[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
"

BDEPEND="app-arch/unzip"

dir=opt/${PN}

QA_PREBUILT="
	${dir:1}/guis/libmojosetupgui_ncurses.so
	${dir:1}/data/*
	${dir:1}/data/pb/*.so
"

src_unpack() {
	# exit status of 1 should just be warnings, not corrupt archive
	unpack_zip ${A}
}

src_install() {
	insinto "${dir}"
	doins -r guis scripts

	cd data || die
	insinto "${dir}"/data
	doins -r base pb etqw_icon.png
	dodoc README.txt EULA.txt copyrights.txt etqwtv.txt

	exeinto "${dir}"/data
	doexe etqw *\.x86 etqw-* libCgx86* libSDL* *.sh

	make_wrapper ${PN} ./etqw.x86 "${dir}"/data "${dir}"/data
	# Matches with desktop entry for enemy-territory-truecombat
	make_desktop_entry ${PN} "Enemy Territory - Quake Wars (Demo)"

	make_wrapper ${PN}-ded ./etqwded.x86 "${dir}"/data "${dir}"/data
}
