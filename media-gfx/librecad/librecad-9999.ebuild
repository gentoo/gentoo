# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3 qmake-utils

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/LibreCAD/LibreCAD.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="3d debug doc tools qt4 +qt5"
REQUIRED_USE="qt5"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	dev-libs/boost:=
	dev-cpp/muParser
	media-libs/freetype:2"

RDEPEND="${DEPEND}"
S="${WORKDIR}/librecad-${PV}"

src_prepare() {
	# currently RS_VECTOR3D causes an internal compiler error on GCC-4.8
	use 3d || sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro || die
}

src_configure() {
	eqmake5 -r
}

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share
	doins -r unix/appdata
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && insinto html && dodoc -r librecad/support/doc/*
	insinto /usr/share/appdata
	doins unix/appdata/librecad.appdata.xml
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
