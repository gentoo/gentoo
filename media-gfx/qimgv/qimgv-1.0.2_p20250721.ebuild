# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=a8e335b75b0767fd2ea2e1c9145f89a866d002b2
inherit cmake xdg

DESCRIPTION="Cross-platform image viewer with webm support, written in Qt"
HOMEPAGE="https://github.com/easymodo/qimgv"
SRC_URI="https://github.com/easymodo/${PN}/archive/${COMMIT}.tar.gz -> ${P:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif kde opencv video"

DEPEND="
	dev-qt/qtbase:6[concurrent,gui,opengl,widgets]
	dev-qt/qtsvg:6
	exif? ( media-gfx/exiv2:= )
	kde? ( kde-frameworks/kwindowsystem:6 )
	opencv? ( media-libs/opencv:= )
	video? ( media-video/mpv:=[libmpv] )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=OFF
		-DEXIV2=$(usex exif)
		-DKDE_SUPPORT=$(usex kde)
		-DOPENCV_SUPPORT=$(usex opencv)
		-DVIDEO_SUPPORT=$(usex video)
	)
	cmake_src_configure
}
