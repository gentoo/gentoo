# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils qmake-utils

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${PV/_/}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="3d debug doc tools qt4 +qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
		dev-qt/qthelp:4
	)
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
S="${WORKDIR}/LibreCAD-${PV}"

src_prepare() {
# 	epatch "${FILESDIR}/iota-fix-2.1.1.patch"

	# currently RS_VECTOR3D causes an internal compiler error on GCC-4.8
	if ! use 3d; then
		sed -i -e '/RS_VECTOR2D/ s/^#//' librecad/src/src.pro || die
	fi
}

src_configure() {
	if use qt4; then
		eqmake4 -r
	else
		eqmake5 -r
	fi
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
