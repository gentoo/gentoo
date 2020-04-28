# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

MY_PN="WorldOfGoo"

DESCRIPTION="A puzzle game with a strong emphasis on physics (GOG edition)"
HOMEPAGE="https://2dboy.com/"
SRC_URI="world_of_goo_${PV//./_}.sh"

LICENSE="2dboy-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch strip bundled-libs? ( splitdebug )"

BDEPEND="app-arch/unzip"

RDEPEND="
	!bundled-libs? (
		media-libs/libsdl2[opengl,sound,video]
		media-libs/sdl2-mixer[vorbis]
	)
	>=sys-devel/gcc-3.4
	sys-libs/glibc
	virtual/opengl
	!games-puzzle/world-of-goo
	!games-puzzle/world-of-goo-hb
"

dir="/opt/${PN%-*}"
S="${WORKDIR}"
QA_PREBUILT="${dir#/}/*"

pkg_nofetch() {
	elog "Please buy and download ${A} from:"
	elog "  https://www.gog.com/game/world_of_goo"
	elog "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${dir}"
	newexe data/noarch/game/${MY_PN}.bin.x86$(usex amd64 _64) ${MY_PN}.bin
	dosym "../..${dir}"/${MY_PN}.bin /usr/bin/${PN%-*}

	insinto "${dir}"
	doins -r data/noarch/game/game/
	use bundled-libs && doins -r data/noarch/game/lib$(usex amd64 64)/

	newicon -s 256 data/noarch/game/gooicon.png ${PN%-*}.png
	make_desktop_entry ${PN%-*} "World of Goo" ${PN%-*}

	dodoc data/noarch/docs/linux-issues.txt
	docinto html
	dodoc data/noarch/game/readme.html
}
