# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

MY_PN="WorldOfGoo"

DESCRIPTION="A puzzle game with a strong emphasis on physics (Humble Bundle edition)"
HOMEPAGE="https://2dboy.com/"
SRC_URI="${MY_PN}.Linux.${PV}.sh"

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
	!games-puzzle/world-of-goo-gog
"

dir="/opt/${PN%-*}"
S="${WORKDIR}"
QA_PREBUILT="${dir#/}/*"

pkg_nofetch() {
	elog "If you bought directly from 2DBOY then download ${A} from:"
	elog "  https://2dboy.com/ReceptionistBot/orderLookup.php"
	elog
	elog "Otherwise please buy and download ${A} from:"
	elog "  https://www.humblebundle.com/store/product/worldofgoo"
	elog
	elog "Then move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${dir}"
	newexe data/x86$(usex amd64 _64 "")/${MY_PN}.bin.x86$(usex amd64 _64 "") ${MY_PN}.bin
	dosym "../..${dir}"/${MY_PN}.bin /usr/bin/${PN%-*}

	insinto "${dir}"
	doins -r data/noarch/game/
	use bundled-libs && doins -r data/x86$(usex amd64 _64 "")/lib$(usex amd64 64 "")/

	newicon -s 256 data/noarch/game/gooicon.png ${PN%-*}.png
	make_desktop_entry ${PN%-*} "World of Goo" ${PN%-*}

	docinto html
	dodoc data/noarch/readme.html
}
