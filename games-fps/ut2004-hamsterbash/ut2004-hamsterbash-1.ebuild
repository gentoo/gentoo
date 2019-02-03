# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MOD_DESC="Cute and violent hamster cage rampage mod"
MOD_NAME="Hamster Bash"
MOD_DIR="hamsterbash"

inherit unpacker games games-mods

HOMEPAGE="https://www.moddb.com/mods/hamsterbash"
SRC_URI="HamsterBashFinal.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "${HOMEPAGE}"
	elog "and move it to your DISTDIR directory."
}

src_prepare() {
	mv -f HamsterBash ${MOD_DIR} || die
	rm -rf System
}
