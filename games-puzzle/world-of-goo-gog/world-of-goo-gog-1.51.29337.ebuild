# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils		# eutils for make_wrapper()

MY_PN="WorldOfGoo"

DESCRIPTION="A puzzle game with a strong emphasis on physics (GOG edition)"
HOMEPAGE="http://2dboy.com/"
SRC_URI="world_of_goo_${PV//./_}.sh"

LICENSE="2dboy-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="fetch bindist strip bundled-libs? ( splitdebug )"

DEPEND="app-arch/unzip"
RDEPEND="!bundled-libs? (
		media-libs/libsdl2[alsa,sound,opengl,video]
		media-libs/sdl2-mixer[vorbis]
	)
	sys-libs/glibc
	virtual/opengl
	virtual/glu
	>=sys-devel/gcc-3.4
	!games-puzzle/world-of-goo
	!games-puzzle/world-of-goo-hb"

dir="/opt/${PN%-*}"

QA_PREBUILT="${dir:1}/${MY_PN}.bin.x86
	${dir:1}/${MY_PN}.bin.x86_64"

pkg_nofetch() {
	elog "Download ${A} from www.gog.com"
	elog "and place it in your DISTDIR directory."
}

src_unpack() {
	unzip -d "${S}" "${DISTDIR}/${A}"
}

src_install() {
	exeinto "${dir}"
	doexe data/noarch/game/${MY_PN}.bin.x86$(usex amd64 _64)

	make_wrapper "${PN%-*}" "${dir}"/${MY_PN}.bin.x86$(usex amd64 _64) \
		$(use bundled-libs && (printf '"%s" "%s/lib%s"' "${dir}" "${dir}" $(usex amd64 64) || die))

	insinto "${dir}"
	doins -r data/noarch/game/game
	use bundled-libs && doins -r data/noarch/game/lib$(usex amd64 64)
	newicon data/noarch/game/game/gooicon.png ${PN%-*}.png

	make_desktop_entry ${PN%-*} "World of Goo" ${PN%-*}

	dodoc data/noarch/docs/linux-issues.txt
	docinto html
	dodoc data/noarch/game/readme.html
}
