# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit cmake-utils python-single-r1

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="http://www.openshotvideo.com/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav +python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	media-gfx/imagemagick
	media-libs/libopenshot-audio
	libav? ( media-video/libav:=[encode,x264,xvid,vpx,mp3,theora] )
	!libav? ( media-video/ffmpeg:0=[encode,x264,xvid,vpx,mp3,theora] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	python? ( dev-lang/swig )
	test? ( dev-libs/unittest++ )
"

# https://github.com/OpenShot/libopenshot/pull/19
PATCHES=( "${FILESDIR}/${P}-fix-tests-exit-code.patch" )

S="${WORKDIR}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	use test || cmake_comment_add_subdirectory tests
	pushd src > /dev/null || die
	if use python; then
		pushd bindings > /dev/null || die
		cmake_comment_add_subdirectory ruby # TODO: support ruby
		popd > /dev/null || die
	else
		cmake_comment_add_subdirectory bindings
	fi
	popd > /dev/null || die
	cmake-utils_src_prepare
}

src_configure() {
	if use python; then
		local mycmakeargs=(
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DPYTHON_LIBRARY="$(python_get_library_path)"
		)
	fi
	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/tests" > /dev/null || die
	./openshot-test || die "Tests failed"
	popd > /dev/null || die
}
