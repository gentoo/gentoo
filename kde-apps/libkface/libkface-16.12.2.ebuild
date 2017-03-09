# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="https://projects.kde.org/projects/kde/kdegraphics/libs/libkface"

LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	media-libs/opencv:=
	|| ( <media-libs/opencv-3.0.0 >=media-libs/opencv-3.1.0-r6[contrib] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-16.11.80-opencv3.2-gentoo-3.1.patch" ) # not upstreamable like that

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV3=$(has_version ">=media-libs/opencv-3" && echo yes || echo no)
	)

	kde5_src_configure
}
