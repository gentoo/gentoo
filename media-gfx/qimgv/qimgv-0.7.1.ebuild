# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="A cross-platform image viewer with webm support. Written in qt5"
HOMEPAGE="https://github.com/easymodo/qimgv"
SRC_URI="https://github.com/easymodo/qimgv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde video"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde? ( kde-frameworks/kwindowsystem:5 )
	video? ( media-video/mpv[libmpv] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	eapply_user
	# respect make.conf CXXFLAGS
	sed -i -e '/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O3")/d' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKDE_BLUR=$(usex kde)
		-DVIDEO_SUPPORT=$(usex video)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
