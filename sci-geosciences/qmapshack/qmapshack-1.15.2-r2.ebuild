# Copyright 1999-2021 Gentoo Authors
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
	dev-libs/quazip:0=
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
	sci-libs/gdal
	>=sci-libs/proj-6.0.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}"/${PN}-V_${PV}

PATCHES=(
	"${S}"/FindPROJ4.patch
	"${FILESDIR}"/${P}-no-hacks-kthxbye.patch
)

src_prepare() {
	cmake_src_prepare

	# TODO: upstream
	if has_version ">=dev-libs/quazip-1.0"; then
		sed -e "/^find_package(QuaZip5/s/5          /-Qt5 CONFIG/" \
			-i CMakeLists.txt || die

		sed -e "s/\${QUAZIP_LIBRARIES}/QuaZip::QuaZip/" \
			-i src/qmapshack/CMakeLists.txt || die
	fi
}

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
}
