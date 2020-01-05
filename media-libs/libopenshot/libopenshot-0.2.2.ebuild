# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit cmake-utils python-single-r1 toolchain-funcs versionator

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="http://www.openshotvideo.com/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+imagemagick libav +python test"
# https://github.com/OpenShot/libopenshot/issues/43
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	net-libs/cppzmq
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	>=media-libs/libopenshot-audio-0.1.4
	imagemagick? ( >=media-gfx/imagemagick-7:0=[cxx] )
	libav? ( media-video/libav:=[encode,x264,xvid,vpx,mp3,theora] )
	!libav? ( media-video/ffmpeg:0=[encode,x264,xvid,vpx,mp3,theora] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	python? ( dev-lang/swig )
	test? ( dev-libs/unittest++ )
"

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
	cmake-utils_src_prepare
	# https://github.com/OpenShot/libopenshot/issues/17
	use test || cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_RUBY=OFF # TODO: add ruby support
		-DENABLE_PYTHON=$(usex python)
		$(cmake-utils_use_find_package imagemagick ImageMagick)
	)
	use python && mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make test
}

src_install() {
	cmake-utils_src_install
	python_optimize
}
