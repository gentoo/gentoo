# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit cmake-utils python-single-r1 versionator

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="http://www.openshotvideo.com/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+imagemagick libav +python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	media-libs/libopenshot-audio
	imagemagick? ( media-gfx/imagemagick:0[cxx] )
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
PATCHES=( "${FILESDIR}/${PN}-0.1.0-fix-tests-exit-code.patch" )

S="${WORKDIR}"

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
	if use python; then
		mycmakeargs+=(
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
