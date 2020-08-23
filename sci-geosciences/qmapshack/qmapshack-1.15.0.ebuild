# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
SRC_URI="https://github.com/Maproom/${PN}/archive/V_1.15.0.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtwebengine:5[widgets]
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtprintsupport:5
	dev-qt/qtpositioning:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	dev-qt/designer:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qthelp:5
	dev-libs/quazip
	>=sci-geosciences/routino-3.1.1
	sci-libs/gdal
	>=sci-libs/proj-6.0.0:=
	sci-libs/alglib"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

PATCHES=( "${FILESDIR}"/${PN}-positioning.patch "${FILESDIR}"/${PN}-qt-5.15.patch )
S="${WORKDIR}"/${PN}-V_${PV}

src_prepare() {
	cmake-utils_src_prepare
	cp "${FILESDIR}"/FindPROJ4.cmake cmake/Modules/ || die
}

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake-utils_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
}
