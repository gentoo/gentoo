# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake bash-completion-r1 toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
	inherit git-r3
else
	SRC_URI="https://gmic.eu/files/source/${PN}_${PV}.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="https://gmic.eu/ https://github.com/GreycLab/gmic"

LICENSE="CeCILL-2 GPL-3"
SLOT="0"
IUSE="cli curl ffmpeg fftw gimp graphicsmagick jpeg opencv openexr openmp png qt5 tiff X zlib"
REQUIRED_USE="
	gimp? ( png zlib fftw X )
	qt5? ( png zlib fftw X )
"

MIN_QT_VER="5.2.0"
QT_DEPEND="
	>=dev-qt/qtcore-${MIN_QT_VER}:5=
	>=dev-qt/qtgui-${MIN_QT_VER}:5=
	>=dev-qt/qtnetwork-${MIN_QT_VER}:5=
	>=dev-qt/qtwidgets-${MIN_QT_VER}:5=
"
DEPEND="
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gimp? (
		media-gfx/gimp:0/2
		${QT_DEPEND}
	)
	graphicsmagick? ( media-gfx/graphicsmagick:0= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opencv? ( >=media-libs/opencv-2.3.1a-r1:0= )
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:=
	)
	png? ( media-libs/libpng:0= )
	qt5? ( ${QT_DEPEND} )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? ( sys-libs/zlib:0= )"
RDEPEND="${DEPEND}
	ffmpeg? ( media-video/ffmpeg:0= )
"
BDEPEND="
	virtual/pkgconfig
	gimp? ( dev-qt/linguist-tools:5 )
	qt5? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0_ipa-sra.patch
	"${FILESDIR}"/${PN}-3.0.1-openexr-3-imath.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
	sed -i '/CMAKE_CXX_FLAGS/s/-g //' CMakeLists.txt || die

	if use gimp || use qt5; then
		# respect user flags
		sed -e '/CMAKE_CXX_FLAGS_RELEASE/d' \
			-e '/${CMAKE_EXE_LINKER_FLAGS} -s/d' \
			-i gmic-qt/CMakeLists.txt || die
		local S="${S}/gmic-qt"
		# Bug #753377
		local PATCHES=()
		cmake_src_prepare
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=no
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
	use qt5 && { BUILD_DIR="${BUILD_DIR}"/qt5 cmake_src_compile || die "failed building qt5 GUI" ; }
}

src_install() {
	cmake_src_install

	use cli && newbashcomp "${BUILD_DIR}"/resources/gmic_bashcompletion.sh ${PN}

	local PLUGINDIR="/usr/$(get_libdir)/gimp/2.0/plug-ins"
	insinto "${PLUGINDIR}"
	doins resources/gmic_cluts.gmz

	# install gmic-qt frontends
	if use gimp; then
		exeinto "${PLUGINDIR}"
		doexe "${BUILD_DIR}"/gimp/gmic_gimp_qt
	fi
	use qt5 && dobin "${BUILD_DIR}"/qt5/gmic_qt
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -le "3.0.0"; then
				einfo "Note that starting with version 3.0.1 ${CATEGORY}/${PN} no longer provides a Krita interface."
				einfo "Please use the built-in G'MIC plugin provided with Krita 5 instead."
				break
			fi
		done
	fi
}
