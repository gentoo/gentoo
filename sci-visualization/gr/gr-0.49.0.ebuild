# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Universal framework for cross-platform visualization applications"
HOMEPAGE="http://gr-framework.org/"
SRC_URI="https://github.com/sciapp/gr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo ffmpeg opengl postscript qt5 tiff truetype X"

DEPEND="
	media-libs/fontconfig
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/qhull
	sys-libs/zlib
	cairo? ( x11-libs/cairo )
	ffmpeg? ( media-video/ffmpeg )
	opengl? (
		media-libs/glfw
		virtual/opengl
	)
	postscript? ( app-text/ghostscript-gpl )
	qt5? ( dev-qt/qtgui:5 )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-paths.patch"
)

src_configure() {
	use cairo || mycmakeargs+=( -DCAIRO_LIBRARY= )
	use opengl || mycmakeargs+=( -DGLFW_LIBRARY= )
	use postscript || mycmakeargs+=( -DGS_LIBRARY= )
	use ffmpeg || mycmakeargs+=( -DFFMPEG_INCLUDE_DIR= )
	use truetype || mycmakeargs+=( -DFREETYPE_LIBRARY= )
	use tiff || mycmakeargs+=( -DTIFF_LIBRARY= )

	# todo: Qt5, X11 automagic

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.a' -delete
}
