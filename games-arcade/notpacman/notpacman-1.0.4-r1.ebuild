# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg

DESCRIPTION="Mashup of \"Not\" and \"Pacman\""
HOMEPAGE="https://stabyourself.net/notpacman/"
SRC_URI="https://stabyourself.net/dl.php?file=notpacman-1004/notpacman-linux.zip -> ${P}.zip
	https://dev.gentoo.org/~chewi/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.7"
RDEPEND=">=games-engines/love-0.7.2:${LVSLOT}
	media-libs/devil[png]"
BDEPEND="app-arch/unzip"

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	newexe not_pacman.love ${PN}.love

	einstalldocs

	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}
