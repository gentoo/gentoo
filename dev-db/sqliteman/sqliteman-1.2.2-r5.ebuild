# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Powerful GUI manager for the Sqlite3 database"
HOMEPAGE="https://sourceforge.net/projects/sqliteman/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	>=x11-libs/qscintilla-2.10.3:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-lpthread.patch"
	"${FILESDIR}/${P}-qt5.patch"
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-desktop.patch"
)

src_prepare() {
	# remove bundled lib
	rm -rf ${PN}/qscintilla2 || die

	append-flags -fPIC
	cmake_src_prepare
}
