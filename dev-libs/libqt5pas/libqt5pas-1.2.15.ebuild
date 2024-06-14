# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Get PV from lcl/interfaces/qt6/cbindings/Qt6Pas.pro
inherit qmake-utils

LAZARUS_PV=3.0

# We want to keep the version here in correspondence with dev-lang/lazarus
# so dev-lang/lazarus can use the bindings.
MY_P="lazarus-${LAZARUS_PV}-0"

DESCRIPTION="Free Pascal Qt5 bindings library updated by lazarus IDE"
HOMEPAGE="https://gitlab.com/freepascal.org/lazarus/lazarus"
SRC_URI="https://downloads.sourceforge.net/lazarus/${MY_P}.tar.gz"
S="${WORKDIR}/lazarus/lcl/interfaces/qt5/cbindings"

LICENSE="LGPL-3"
SLOT="0/${LAZARUS_PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtx11extras:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 "QT += x11extras" Qt5Pas.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
