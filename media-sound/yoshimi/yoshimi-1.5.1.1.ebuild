# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A software synthesizer based on ZynAddSubFX"
HOMEPAGE="http://yoshimi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lv2"

RDEPEND="
	>=dev-libs/mxml-2.5
	>=media-libs/alsa-lib-1.0.17
	media-libs/fontconfig
	media-libs/libsndfile
	>=media-sound/jack-audio-connection-kit-0.115.6
	sci-libs/fftw:3.0
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib
	x11-libs/cairo[X]
	x11-libs/fltk:1[opengl]
	lv2? ( media-libs/lv2 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
"

CMAKE_USE_DIR="${WORKDIR}/${P}/src"

src_prepare() {
	mv Change{l,L}og || die
	sed -i \
		-e '/set (CMAKE_CXX_FLAGS_RELEASE/d' \
		-e "s:lib/lv2:$(get_libdir)/lv2:" \
		src/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLV2Plugin=$(usex lv2)
	)
	cmake-utils_src_configure
}
