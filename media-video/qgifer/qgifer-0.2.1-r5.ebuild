# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils

DESCRIPTION="A video-based animated GIF creator"
HOMEPAGE="https://sourceforge.net/projects/qgifer/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug imagemagick opencv3 +giflib5"

RDEPEND="giflib5? ( >=media-libs/giflib-5.1:= )
	!giflib5? ( <=media-libs/giflib-5.0:= )
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	imagemagick? ( media-gfx/imagemagick:0 )
	!opencv3? ( <media-libs/opencv-3.0.0:0=[ffmpeg] )
	opencv3? ( >=media-libs/opencv-3.0.0:0=[ffmpeg] )
	virtual/ffmpeg:0"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-source"

PATCHES=( "${FILESDIR}/${P}-desktop.patch" )

src_prepare(){
	use opencv3 && PATCHES+=( "${FILESDIR}/${P}-opencv3.patch" )
	use giflib5 && PATCHES+=( "${FILESDIR}/${P}-giflib_5.0.6_to_5.1.0.patch"
		"${FILESDIR}/${P}-giflib5.patch"
	)

	cmake-utils_src_prepare

	# Fix the doc path
	sed -i -e "s|share/doc/qgifer|share/doc/${PF}|" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		 $(usex debug -DRELEASE_MODE=OFF '')
	)

	cmake-utils_src_configure
}
