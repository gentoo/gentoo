# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CrossCode DLC unlocking post-game content"
HOMEPAGE="https://radicalfishgames.itch.io/crosscode-a-new-home"
SRC_URI="new-home.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	>=games-rpg/crosscode-1.4.2.2
"

BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}"
DIR="/usr/share/crosscode"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	insinto "${DIR}/assets/extension"
	doins -r post-game
}
