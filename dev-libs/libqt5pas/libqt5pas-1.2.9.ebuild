# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_P="lazarus-2.2.4-0"

DESCRIPTION="Free Pascal Qt5 bindings library updated by lazarus IDE."
HOMEPAGE="https://gitlab.com/freepascal.org/lazarus/lazarus"
SRC_URI="https://downloads.sourceforge.net/lazarus/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-3"
SLOT="0/2.2"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtx11extras:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
"

S="${WORKDIR}/lazarus/lcl/interfaces/qt5/cbindings"

src_configure() {
	eqmake5 "QT += x11extras" Qt5Pas.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
