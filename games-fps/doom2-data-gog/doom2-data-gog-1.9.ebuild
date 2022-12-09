# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for DOOM II and the Master Levels from gog.com"
HOMEPAGE="https://www.gog.com/en/game/doom_ii_final_doom"
SRC_URI="setup_doom_ii_with_master_levels_${PV}_(28044).exe"
LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~x86"
RESTRICT="bindist fetch"

BDEPEND="app-arch/innoextract"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	innoextract --extract --lowercase \
		--include=/doom2/DOOM2.WAD \
		--include=/master/wads \
		--include=/Manual.pdf \
		"${DISTDIR}/${A}" || die

	insinto /usr/share/doom
	doins doom2/doom2.wad

	insinto /usr/share/doom/master
	doins master/wads/*.wad

	dodoc manual.pdf
	docinto master
	dodoc master/wads/*.txt
}
