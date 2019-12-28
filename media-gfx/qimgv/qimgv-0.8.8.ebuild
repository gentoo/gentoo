# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg-utils

DESCRIPTION="A cross-platform image viewer with webm support, written in qt5"
HOMEPAGE="https://github.com/easymodo/qimgv"
SRC_URI="https://github.com/easymodo/qimgv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="exif kde video"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	exif? ( media-gfx/exiv2:= )
	kde? ( kde-frameworks/kwindowsystem:5 )
	video? ( media-video/mpv[libmpv] )
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	cmake-utils_src_prepare
	# respect make.conf CXXFLAGS
	sed -i -e '/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -lstdc++fs -O3")/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DEXIV2=$(usex exif)
		-DKDE_SUPPORT=$(usex kde)
		-DVIDEO_SUPPORT=$(usex video)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
