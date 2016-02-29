# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

MY_PN="BDSup2SubPlusPlus"
DESCRIPTION="C++ port of BDSup2Sub"
HOMEPAGE="https://github.com/amichaelt/BDSup2SubPlusPlus"
SRC_URI="https://github.com/amichaelt/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libqxt
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}/src"

src_configure() {
	eqmake4 ${PN}.pro
}

src_install() {
	dobin ${PN}
}
