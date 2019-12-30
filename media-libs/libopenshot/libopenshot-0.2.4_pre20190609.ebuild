# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake python-single-r1 toolchain-funcs

COMMIT="0d4ea7fe71e88bcee4a7fd1404bd52c8e2169997"

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/17"
KEYWORDS="amd64 x86"
IUSE="doc examples +imagemagick libav +python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	net-libs/cppzmq
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	>=media-libs/libopenshot-audio-0.1.9_pre20190502:0=
	imagemagick? ( >=media-gfx/imagemagick-7:0=[cxx] )
	libav? ( media-video/libav:0=[encode,x264,xvid,vpx,mp3,theora] )
	!libav? ( media-video/ffmpeg:0=[encode,x264,xvid,vpx,mp3,theora] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig )
	test? ( dev-libs/unittest++ )
"

S="${WORKDIR}/${PN}-${COMMIT}"

# From Mageia
# https://github.com/OpenShot/libopenshot/issues/60
PATCHES=( ${FILESDIR}/${PN}-0.2.2-imagemagick7.patch )

check_compiler() {
	if [[ ${MERGE_TYPE} != binary ]] && ! tc-has-openmp; then
		eerror "${P} requires a compiler with OpenMP support. Your current"
		eerror "compiler does not support it. If you use gcc, you can"
		eerror "re-emerge it with the 'openmp' use flag enabled."
		die "The current compiler does not support OpenMP"
	fi
}

pkg_pretend() {
	check_compiler
}

pkg_setup() {
	check_compiler
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# https://github.com/OpenShot/libopenshot/issues/17
	use test || cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_RUBY=OFF # TODO: add ruby support
		-DENABLE_PYTHON=$(usex python)
		$(cmake_use_find_package imagemagick ImageMagick)
	)
	use python && mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_test() {
	cmake_build os_test
}

src_install() {
	local DOCS=( AUTHORS README.md doc/HW-ACCEL.md )
	use examples && DOCS+=( src/examples/ )
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )

	cmake_src_install
	use python && python_optimize
}
