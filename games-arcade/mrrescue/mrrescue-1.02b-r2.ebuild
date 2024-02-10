# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg

DESCRIPTION="Arcade 2d action game based around evacuating civilians from burning buildings"
HOMEPAGE="https://tangramgames.dk/games/mrrescue/"
SRC_URI="https://github.com/SimonLarsen/mrrescue/releases/download/v${PV}/${P}-love.zip
	mirror://gentoo/${PN}.png"
S="${WORKDIR}/${P}-love"

LICENSE="CC-BY-SA-3.0 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.8"
RDEPEND="games-engines/love:${LVSLOT}"
BDEPEND="app-arch/unzip"

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	einstalldocs

	doicon -s 64 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}
