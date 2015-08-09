# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="Generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
SRC_URI="https://github.com/LibreCAD/LibreCAD/archive/${PV/_/}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc tools"

DEPEND="
	dev-cpp/muParser
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	dev-qt/qtsvg:4
	dev-libs/boost
	media-libs/freetype
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/LibreCAD-${PV}"

src_install() {
	dobin unix/librecad
	use tools && dobin unix/ttf2lff
	insinto /usr/share/${PN}
	doins -r unix/resources/*
	use doc && dohtml -r librecad/support/doc/*
	doicon librecad/res/main/${PN}.png
	make_desktop_entry ${PN} LibreCAD ${PN} Graphics
}
