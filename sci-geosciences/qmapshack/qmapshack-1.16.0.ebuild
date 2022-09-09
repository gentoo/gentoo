# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
SRC_URI="https://github.com/Maproom/${PN}/archive/V_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/quazip:0=[qt5(+)]
	dev-qt/designer:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwebengine:5[widgets]
	>=sci-geosciences/routino-3.1.1
	sci-libs/alglib
	sci-libs/gdal:=
	>=sci-libs/proj-8:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}"/${PN}-V_${PV}

src_prepare() {
	cmake_src_prepare
	xdg_src_prepare
}

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
}
