# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit cmake-utils python-single-r1 toolchain-funcs versionator

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="http://www.openshotvideo.com/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+imagemagick libav +python test"
# https://github.com/OpenShot/libopenshot/issues/36
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	net-libs/cppzmq
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	media-libs/libopenshot-audio
	imagemagick? ( media-gfx/imagemagick:0=[cxx] )
	libav? ( media-video/libav:=[encode,x264,xvid,vpx,mp3,theora] )
	!libav? ( media-video/ffmpeg:0=[encode,x264,xvid,vpx,mp3,theora] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	python? ( dev-lang/swig )
	test? ( dev-libs/unittest++ )
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && ! tc-has-openmp; then
		eerror "${P} requires a compiler with OpenMP support. Your current"
		eerror "compiler does not support it. If you use gcc, you can"
		eerror "re-emerge it with the 'openmp' use flag enabled."
		die "The current compiler does not support OpenMP"
	fi
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# https://github.com/OpenShot/libopenshot/issues/17
	use test || cmake_comment_add_subdirectory tests
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_RUBY=OFF # TODO: add ruby support
		-DENABLE_PYTHON=$(usex python)
		-DCMAKE_DISABLE_FIND_PACKAGE_ImageMagick=$(usex !imagemagick)
	)
	use python && mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/tests" > /dev/null || die
	./openshot-test || die "Tests failed"
	popd > /dev/null || die
}

src_install() {
	cmake-utils_src_install
	python_optimize
}
