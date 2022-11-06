# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A cross-platform image viewer with webm support, written in qt5"
HOMEPAGE="https://github.com/easymodo/qimgv"
SRC_URI="https://github.com/easymodo/qimgv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif kde opencv video"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	exif? ( media-gfx/exiv2:= )
	kde? ( kde-frameworks/kwindowsystem:5 )
	opencv? ( media-libs/opencv:= )
	video? ( media-video/mpv:=[libmpv] )
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-libmpv-api2.patch
)

src_configure() {
	local mycmakeargs=(
		-DEXIV2=$(usex exif)
		-DKDE_SUPPORT=$(usex kde)
		-DOPENCV_SUPPORT=$(usex opencv)
		-DVIDEO_SUPPORT=$(usex video)
	)
	cmake_src_configure
}
