# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils

DESCRIPTION="A packet generator and analyzer"
HOMEPAGE="http://ostinato.org/"
SRC_URI="https://github.com/pstavirs/ostinato/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#https://github.com/pstavirs/ostinato/issues/173
# libpcap dep is versioned to pull in the fix for #602098
DEPEND="dev-libs/protobuf:=
	>=net-libs/libpcap-1.8.1-r2
	dev-qt/qtscript:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 PREFIX="${ED}/usr" ost.pro
}
