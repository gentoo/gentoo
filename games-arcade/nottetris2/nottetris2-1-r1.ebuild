# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils

DESCRIPTION="The spiritual successor of the classic Tetris mixed with physics"
HOMEPAGE="https://stabyourself.net/nottetris2/"
SRC_URI="https://stabyourself.net/dl.php?file=nottetris2/nottetris2-linux.zip -> ${P}.zip"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LVSLOT="0.7"
RDEPEND=">=games-engines/love-0.7.2:${LVSLOT}
	 media-libs/devil[png]
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	local dir=/usr/share/love/${PN}

	exeinto "${dir}"
	newexe "Not Tetris 2.love" ${PN}.love

	newdoc "Not Readme.txt" README

	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}
}
