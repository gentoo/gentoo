# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

QT_VER=5.7.1
inherit cmake-utils flag-o-matic xdg-utils

DESCRIPTION="Powerful GUI manager for the Sqlite3 database"
HOMEPAGE="https://sourceforge.net/projects/sqliteman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtcore-${QT_VER}:5
	>=dev-qt/qtgui-${QT_VER}:5
	>=dev-qt/qtsql-${QT_VER}:5[sqlite]
	>=dev-qt/qtwidgets-${QT_VER}:5
	>=x11-libs/qscintilla-2.9.4:=[qt5(+)]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-lpthread.patch"
	"${FILESDIR}/${P}-qt5.patch"
)

src_prepare() {
	# remove bundled lib
	rm -rf "${S}"/${PN}/qscintilla2 || die

	append-flags -fPIC
	cmake-utils_src_prepare
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
