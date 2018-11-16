# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="http://librepcb.org/"
#Fix these variables as soon as a 0.1.0 (no -rcX) release is out.
MY_V="0.1.0"
SRC_URI="https://download.${PN}.org/releases/${MY_V}-rc2/${PN}-${MY_V}-rc2-source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${MY_V}-rc2"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtwebkit:5
	dev-qt/qtxml:5
	sys-libs/zlib
"

DEPEND="${RDEPEND}"

src_configure() {
	eqmake5 -r PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
