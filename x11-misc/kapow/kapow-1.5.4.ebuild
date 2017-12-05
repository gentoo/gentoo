# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils

DESCRIPTION="A punch clock program designed to easily keep track of your hours"
HOMEPAGE="https://gottcode.org/kapow/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
"

DOCS=( ChangeLog README )

src_configure() {
	eqmake5 kapow.pro PREFIX=/usr
}

src_install() {
	export INSTALL_ROOT="${D}"
	default
}
