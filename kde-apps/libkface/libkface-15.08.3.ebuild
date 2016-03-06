# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="https://projects.kde.org/projects/kde/kdegraphics/libs/libkface"

LICENSE="GPL-2"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/opencv-3.0.0:=[contrib]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-15.08.2-opencv3.patch"
	"${FILESDIR}/${PN}-15.08.3-opencv3.1.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV3=ON
	)

	kde4-base_src_configure
}
