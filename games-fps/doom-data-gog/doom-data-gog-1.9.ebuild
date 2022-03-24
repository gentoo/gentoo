# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for The Ultimate DOOM from gog.com"
HOMEPAGE="https://www.gog.com/en/game/the_ultimate_doom"
SRC_URI="setup_the_ultimate_doom_${PV}_(28044).exe"
LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~x86"
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
		--include=/DOOM.WAD \
		--include=/Manual.pdf \
		--include=/Doom\ Bible.pdf \
		"${DISTDIR}/${A}" || die

	insinto /usr/share/doom
	doins doom.wad
	dosym doom.wad /usr/share/doom/udoom.wad

	dodoc manual.pdf
	newdoc "doom bible.pdf" doom-bible.pdf
}
