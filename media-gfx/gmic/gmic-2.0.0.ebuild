# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils bash-completion-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
	inherit git-r3
else
	SRC_URI="http://gmic.eu/files/source/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/ https://github.com/dtschump/gmic"

LICENSE="CeCILL-2 FDL-1.3"
SLOT="0"
IUSE="+cli ffmpeg fftw gimp graphicsmagick jpeg opencv openexr openmp png static-libs tiff X zlib"
REQUIRED_USE="|| ( cli gimp )"

COMMON_DEPEND="
	fftw? ( sci-libs/fftw:3.0[threads] )
	gimp? ( >=media-gfx/gimp-2.4.0 )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( >=media-libs/opencv-2.3.1a-r1 )
	openexr? (
		media-libs/ilmbase
		media-libs/openexr
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? ( sys-libs/zlib )"
RDEPEND="${COMMON_DEPEND}
	ffmpeg? ( media-video/ffmpeg:0 )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.9-flags.patch
	"${FILESDIR}"/${PN}-1.7.9-man.patch
)

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs)
		-DBUILD_CLI=$(usex cli)
		-DBUILD_MAN=$(usex cli)
		-DBUILD_PLUGIN=$(usex gimp)
		-DENABLE_X=$(usex X)
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_FFTW=$(usex fftw)
		-DENABLE_GRAPHICSMAGICK=$(usex graphicsmagick)
		-DENABLE_JPEG=$(usex jpeg)
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_OPENEXR=$(usex openexr)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PNG=$(usex png)
		-DENABLE_TIFF=$(usex tiff)
		-DENABLE_ZLIB=$(usex zlib)
	)

	local CMAKE_BUILD_TYPE="Release"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README
	use cli && newbashcomp resources/${PN}_bashcompletion.sh ${PN}
}
