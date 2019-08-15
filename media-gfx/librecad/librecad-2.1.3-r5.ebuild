# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="https://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${PV/_/}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="debug doc tools"

RDEPEND="
	dev-cpp/muParser
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/freetype:2"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qthelp:5
	dev-qt/qtxml:5
"

S="${WORKDIR}/LibreCAD-${PV}"

PATCHES=( "${FILESDIR}/${P}-qt-5.11.patch" "${FILESDIR}/${P}-gcc-9.patch" )

src_configure() {
	eqmake5 -r
}

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && docinto html && dodoc -r librecad/support/doc/*
	insinto /usr/share/appdata
	doins unix/appdata/librecad.appdata.xml
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
