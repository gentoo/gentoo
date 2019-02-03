# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MOD_DESC="Star Wars mod"
MOD_NAME="Troopers"
MOD_DIR="Troopers"
MOD_ICON="Help/Troopers.ico"

inherit games games-mods

HOMEPAGE="https://www.moddb.com/mods/troopers-dawn-of-destiny/"
SRC_URI="troopersversion${PV/.}zip.zip"

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
	rm -f ${MOD_DIR}/*.{bat,sh}
}
