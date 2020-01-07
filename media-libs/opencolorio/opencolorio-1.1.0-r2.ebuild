# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="http://opencolorio.org/"

SRC_URI="https://github.com/imageworks/OpenColorIO/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs test"
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
	dev-libs/tinyxml
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-fix-compile-error-with-Lut1DOp.cpp.patch"
	"${FILESDIR}/${P}-use-GNUInstallDirs-and-fix-cmake-install-location.patch"
	"${FILESDIR}/${P}-remove-building-of-bundled-programs.patch"
	"${FILESDIR}/${P}-yaml-cpp-0.6.patch"
	"${FILESDIR}/${P}-remove-Werror.patch"
)

S="${WORKDIR}/OpenColorIO-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

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
		-DOCIO_BUILD_STATIC=$(usex static-libs)
		-DOCIO_STATIC_JNIGLUE=OFF
		-DOCIO_BUILD_TRUELIGHT=OFF
		-DUSE_EXTERNAL_LCMS=ON
		-DUSE_EXTERNAL_TINYXML=ON
		-DUSE_EXTERNAL_YAML=ON
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_APPS=$(usex opengl)
		-DOCIO_BUILD_PYGLUE=$(usex python)
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON # They don't build
	)
	cmake_src_configure
}
