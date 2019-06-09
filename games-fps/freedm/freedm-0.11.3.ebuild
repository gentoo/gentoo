# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A 32-level game designed for competitive deathmatch play."
HOMEPAGE="https://freedoom.github.io"
SRC_URI="https://github.com/freedoom/freedoom/releases/download/v${PV}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
|| (
	games-fps/gzdoom
	games-engines/odamex
	games-fps/doomsday
)
"
BDEPEND="app-arch/unzip"

FREEDMWADPATH=/usr/share/doom/${P}

src_install() {
	insinto ${FREEDMWADPATH}
	doins ${PN}.wad
	dodoc CREDITS.txt README.html
}

pkg_postinst() {
	elog "FreeDM WAD file installed into ${FREEDMWADPATH}"
}
