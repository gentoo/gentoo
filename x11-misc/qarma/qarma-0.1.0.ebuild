# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_PV=1

DESCRIPTION="Zenity Clone for Qt"
HOMEPAGE="https://github.com/luebking/qarma"
SRC_URI="https://github.com/luebking/qarma/archive/t${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-t${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin qarma
}
