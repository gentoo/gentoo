# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

DESCRIPTION="A video-based animated GIF creator"
HOMEPAGE="https://sourceforge.net/projects/qgifer/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug imagemagick opencv3"

RDEPEND="media-libs/giflib:0
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	imagemagick? ( media-gfx/imagemagick:0 )
	!opencv3? ( media-libs/opencv:0/2.4[ffmpeg] )
	opencv3? ( media-libs/opencv:0/3.0[ffmpeg] )
	virtual/ffmpeg:0"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8:0"

S="${WORKDIR}/${P}-source"

src_prepare() {
	epatch "${FILESDIR}"/${P}-desktop.patch

	if use opencv3 ; then
		epatch "${FILESDIR}"/${P}-opencv3.patch
	fi
}

src_configure() {
	local mycmakeargs

	use debug && mycmakeargs=( -DRELEASE_MODE=OFF )

	cmake-utils_src_configure
}
