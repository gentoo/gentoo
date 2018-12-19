# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MOD_DESC="Doom 1 conversion for Doom 3"
MOD_NAME="Classic Doom"
MOD_DIR="cdoom"
MOD_ICON="cdoom.ico"

inherit games games-mods

HOMEPAGE="https://www.moddb.com/mods/classic-doom-3"
SRC_URI="classic_doom_3_${PV//.}.zip"

LICENSE="GameFront"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/8748743"
	elog "and move it to your DISTDIR directory."
}

src_prepare() {
	cd ${MOD_DIR} || die
	rm -f *.{bat,url} cdoom_{dll,mac}.pk4
}
