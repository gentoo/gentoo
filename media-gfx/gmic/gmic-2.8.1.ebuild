# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
inherit cmake bash-completion-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
	inherit git-r3
else
	SRC_URI="https://gmic.eu/files/source/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="https://gmic.eu/ https://github.com/dtschump/gmic"

LICENSE="CeCILL-2 GPL-3"
SLOT="0"
IUSE="+cli curl ffmpeg fftw gimp graphicsmagick jpeg krita opencv openexr openmp png qt5 static-libs tiff X zlib"
REQUIRED_USE="
	|| ( cli gimp krita qt5 )
	gimp? ( png zlib fftw X )
	krita? ( png zlib fftw X )
	qt5? ( png zlib fftw X )
"

MIN_QT_VER="5.2.0"
QT_DEPEND="
	>=dev-qt/qtcore-${MIN_QT_VER}:5=
	>=dev-qt/qtgui-${MIN_QT_VER}:5=
	>=dev-qt/qtnetwork-${MIN_QT_VER}:5=
	>=dev-qt/qtwidgets-${MIN_QT_VER}:5=
"
COMMON_DEPEND="
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gimp? (
		>=media-gfx/gimp-2.8.0
		${QT_DEPEND}
	)
	graphicsmagick? ( media-gfx/graphicsmagick:0= )
	jpeg? ( virtual/jpeg:0 )
	krita? ( ${QT_DEPEND} )
	opencv? ( >=media-libs/opencv-2.3.1a-r1:0= )
	openexr? (
		media-libs/ilmbase:0=
		media-libs/openexr:0=
	)
	png? ( media-libs/libpng:0= )
	qt5? ( ${QT_DEPEND} )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? ( sys-libs/zlib:0= )"
RDEPEND="${COMMON_DEPEND}
	ffmpeg? ( media-video/ffmpeg:0= )
"
DEPEND="${COMMON_DEPEND}
	gimp? ( dev-qt/linguist-tools )
	krita? ( dev-qt/linguist-tools )
	qt5? ( dev-qt/linguist-tools )
"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${PN}-2.4.3-curl.patch )
	cmake_src_prepare
	sed -i '/CMAKE_CXX_FLAGS/s/-g //' CMakeLists.txt || die

	if use gimp || use krita || use qt5; then
		# respect user flags
		sed -i '/CMAKE_CXX_FLAGS_RELEASE/d' gmic-qt/CMakeLists.txt || die
		local S="${S}/gmic-qt"
		# fix linking with fftw when thread support is enabled
		PATCHES=( "${FILESDIR}"/${PN}-2.7.1-qt-cmake.patch )
		cmake_src_prepare
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs)
		-DBUILD_CLI=$(usex cli)
		-DBUILD_MAN=$(usex cli)
		-DBUILD_BASH_COMPLETION=$(usex cli)
		-DCUSTOM_CFLAGS=ON
		-DENABLE_CURL=$(usex curl)
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
		-DENABLE_DYNAMIC_LINKING=ON
	)

	cmake_src_configure

	# configure gmic-qt frontends
	local CMAKE_USE_DIR="${S}/gmic-qt"
	mycmakeargs=(
		-DENABLE_DYNAMIC_LINKING=ON
		-DENABLE_CURL=$(usex curl)
		-DGMIC_LIB_PATH="${BUILD_DIR}"
		-DGMIC_PATH="${S}/src"
	)

	if use gimp; then
		mycmakeargs+=( -DGMIC_QT_HOST=gimp )
		BUILD_DIR="${BUILD_DIR}"/gimp cmake_src_configure
	fi

	if use krita; then
		mycmakeargs+=( -DGMIC_QT_HOST=krita )
		BUILD_DIR="${BUILD_DIR}"/krita cmake_src_configure
	fi

	if use qt5; then
		mycmakeargs+=( -DGMIC_QT_HOST=none )
		BUILD_DIR="${BUILD_DIR}"/qt5 cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	# build gmic-qt frontends
	local S="${S}/gmic-qt"
	use gimp && { BUILD_DIR="${BUILD_DIR}"/gimp cmake_src_compile || die "failed building gimp plugin" ; }
	use krita && { BUILD_DIR="${BUILD_DIR}"/krita cmake_src_compile || die "failed building krita plugin" ; }
	use qt5 && { BUILD_DIR="${BUILD_DIR}"/qt5 cmake_src_compile || die "failed building qt5 GUI" ; }
}

src_install() {
	cmake_src_install
	dodoc README
	use cli && newbashcomp "${BUILD_DIR}"/resources/gmic_bashcompletion.sh ${PN}

	local PLUGINDIR="/usr/$(get_libdir)/gimp/2.0/plug-ins"
	insinto "${PLUGINDIR}"
	doins resources/gmic_cluts.gmz

	# install gmic-qt frontends
	if use gimp; then
		exeinto "${PLUGINDIR}"
		doexe "${BUILD_DIR}"/gimp/gmic_gimp_qt
	fi
	use krita && dobin "${BUILD_DIR}"/krita/gmic_krita_qt
	use qt5 && dobin "${BUILD_DIR}"/qt5/gmic_qt
}
