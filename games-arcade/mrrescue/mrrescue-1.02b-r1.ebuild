# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils gnome2-utils

DESCRIPTION="Arcade 2d action game based around evacuating civilians from burning buildings"
HOMEPAGE="https://tangramgames.dk/games/mrrescue/"
SRC_URI="https://github.com/SimonLarsen/mrrescue/releases/download/v${PV}/${P}-love.zip
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="CC-BY-SA-3.0 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-engines/love:0"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${P}-love"

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	einstalldocs

	doicon -s 64 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
