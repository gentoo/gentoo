# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Qt-based Chess Database Utility"
HOMEPAGE="https://chessx.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/chessx/files/chessx/${PV}/${P}.tgz"
S="${WORKDIR}/${PN}-master"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-libs/quazip-1.3-r2:0=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtspeech:6
	dev-qt/qtsvg:6
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-qt/qtbase:6[concurrent]
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-system-quazip-zlib.patch
	"${FILESDIR}"/${P}-install.patch
)

src_configure() {
	eqmake6 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	doicon -s 256 data/images/${PN}.png
	for x in 32 64; do
		newicon -s ${x} data/images/${PN}-${x}.png ${PN}.png
	done
	einstalldocs
}
