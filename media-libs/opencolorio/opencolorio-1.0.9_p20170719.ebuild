# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Compatibility with Python 3 is declared by upstream, but it is broken in fact, check on bump
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="http://opencolorio.org/"

MY_GIT_COMMIT="7e7f10afce97254cdc1295a3594ddd5e6fb555d6"
SRC_URI="https://github.com/imageworks/OpenColorIO/archive/${MY_GIT_COMMIT}.tar.gz \
		-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc opengl pdf python cpu_flags_x86_sse2 test"
REQUIRED_USE="
	doc? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	opengl? (
		media-libs/lcms:2
		media-libs/openimageio
		media-libs/glew:=
		media-libs/freeglut
		virtual/opengl
	)
	python? ( ${PYTHON_DEPS} )
	>=dev-cpp/yaml-cpp-0.5
	dev-libs/tinyxml"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		pdf? ( dev-python/sphinx[latex,${PYTHON_USEDEP}] )
		!pdf? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	)"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-1.0.9-cmake-fixes-v1.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	use python && python_fix_shebang .
}

src_configure() {
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	local mycmakeargs=(
		-DOCIO_BUILD_JNIGLUE=OFF
		-DOCIO_BUILD_NUKE=OFF
		-DOCIO_BUILD_SHARED=ON
		-DOCIO_BUILD_STATIC=OFF
		-DOCIO_STATIC_JNIGLUE=OFF
		-DOCIO_BUILD_TRUELIGHT=OFF
		-DUSE_EXTERNAL_LCMS=ON
		-DUSE_EXTERNAL_TINYXML=ON
		-DUSE_EXTERNAL_YAML=ON
		-DOCIO_BUILD_DOCS="$(usex doc)"
		-DOCIO_BUILD_APPS="$(usex opengl)"
		-DOCIO_BUILD_PDF_DOCS="$(usex pdf)"
		-DOCIO_BUILD_PYGLUE="$(usex python)"
		-DOCIO_USE_SSE="$(usex cpu_flags_x86_sse2)"
		-DOCIO_BUILD_TESTS="$(usex test)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}
