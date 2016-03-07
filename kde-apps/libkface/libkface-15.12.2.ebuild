# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="https://projects.kde.org/projects/kde/kdegraphics/libs/libkface"

LICENSE="GPL-2"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=media-libs/opencv-3:=[contrib]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-opencv3.1.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV3=ON
	)

	kde5_src_configure
}
