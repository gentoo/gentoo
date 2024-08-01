# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Zenity Clone for Qt5"
HOMEPAGE="https://github.com/luebking/qarma"
SRC_URI="https://github.com/luebking/qarma/archive/t${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-t${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin qarma
}
