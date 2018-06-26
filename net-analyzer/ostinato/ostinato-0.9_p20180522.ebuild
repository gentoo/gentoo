# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=9a4e7e7550c6b20a8f0f1393a55036492c1b7703
inherit qmake-utils

DESCRIPTION="A packet generator and analyzer"
HOMEPAGE="https://ostinato.org/"
SRC_URI="https://github.com/pstavirs/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#https://github.com/pstavirs/ostinato/issues/173
# libpcap dep is versioned to pull in the fix for #602098
DEPEND="
	dev-libs/protobuf:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	>=net-libs/libpcap-1.8.1-r2
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}/${P}-buildfix.patch"
	"${FILESDIR}/${P}-no-modeltest.patch"
)

src_configure(){
	eqmake5 PREFIX="${ED}/usr" ost.pro
}
