# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="Zenity Clone for Qt5"
HOMEPAGE="https://github.com/luebking/qarma"
SRC_URI="https://github.com/luebking/qarma/archive/t${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 dev-qt/qtx11extras:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-t${PV}"

src_configure() {
	eqmake5
}

src_install() {
	dobin qarma
}
