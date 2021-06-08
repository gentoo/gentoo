# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg

DESCRIPTION="A game made in 20 hours for a friend. It has explosions"
HOMEPAGE="https://stabyourself.net/trosh/"
SRC_URI="https://stabyourself.net/dl.php?file=trosh/trosh-linux.zip -> ${P}.zip
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.8"
RDEPEND="
	games-engines/love:${LVSLOT}
	media-libs/devil[png]"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	einstalldocs

	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}
