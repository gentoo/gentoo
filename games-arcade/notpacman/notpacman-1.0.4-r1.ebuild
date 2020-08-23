# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils gnome2-utils

DESCRIPTION="A mashup of \"Not\" and \"Pacman\""
HOMEPAGE="https://stabyourself.net/notpacman/"
SRC_URI="https://stabyourself.net/dl.php?file=notpacman-1004/notpacman-linux.zip -> ${P}.zip
	https://dev.gentoo.org/~chewi/distfiles/${PN}.png"

LICENSE="WTFPL-2"
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
	newexe not_pacman.love ${PN}.love

	einstalldocs

	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
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
