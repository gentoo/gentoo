# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Qt5-based Chess Database Utility"
HOMEPAGE="http://chessx.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/chessx/files/chessx/${PV}/${P}.tgz"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/quazip-0.9.1:0=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtspeech:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-system-quazip.patch
	"${FILESDIR}"/${P}-missing-translations.patch
	"${FILESDIR}"/${P}-install.patch
)

src_prepare() {
	xdg_src_prepare
	if has_version "<dev-libs/quazip-1.0"; then
		sed -e "/^PKGCONFIG/s/quazip1-qt5/quazip/" -i chessx.pro || die
	fi
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
