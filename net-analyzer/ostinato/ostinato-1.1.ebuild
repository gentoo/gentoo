# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Packet generator and analyzer"
HOMEPAGE="https://ostinato.org/"
SRC_URI="https://github.com/pstavirs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
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

PATCHES=(
	"${FILESDIR}/${PN}-0.9_p20180522-no-modeltest.patch"
)

src_configure() {
	eqmake5 PREFIX="${ED}/usr" ost.pro
}
