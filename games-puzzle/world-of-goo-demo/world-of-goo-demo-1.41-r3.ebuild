# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg

MY_PN="WorldOfGooDemo"

DESCRIPTION="A puzzle game with a strong emphasis on physics (demo version)"
HOMEPAGE="https://2dboy.com/"
SRC_URI="mirror://sourceforge/slackbuildsdirectlinks/worldofgoo/${MY_PN}.${PV}.tar.gz"

LICENSE="2dboy-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	media-libs/libsdl[opengl,sound,video]
	media-libs/sdl-mixer[vorbis]
	>=sys-devel/gcc-3.4
	sys-libs/glibc
	virtual/opengl
	virtual/glu
"

dir="/opt/${PN}"
S="${WORKDIR}/${MY_PN}"
QA_PREBUILT="${dir#/}/*"

src_install() {
	exeinto "${dir}"
	newexe ${MY_PN%Demo}.bin$(usex amd64 64 32) ${MY_PN%Demo}.bin
	make_wrapper ${PN} ./${MY_PN%Demo}.bin "${dir}"

	insinto "${dir}"
	doins -r icons/ properties/ res/

	local icon size
	for icon in icons/*.{png,svg}; do
		size=${icon##*/}
		size=${size%%[x.]*}
		newicon -s "${size}" "${icon}" "${PN}.${icon##*.}"
	done

	make_desktop_entry ${PN} "World of Goo (Demo)"

	dodoc linux-issues.txt
	docinto html
	dodoc readme.html
}
