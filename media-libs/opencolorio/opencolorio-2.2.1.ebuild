# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit cmake python-single-r1 virtualx

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="https://opencolorio.org https://github.com/AcademySoftwareFoundation/OpenColorIO"
SRC_URI="https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
# minizip-ng: ~arm ~arm64 ~ppc64 ~riscv
# osl: ~riscv
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apps cpu_flags_x86_sse2 doc opengl python static-libs test"
# TODO: drop opengl? It does nothing without building either the apps or the testsuite
REQUIRED_USE="
	apps? ( opengl )
	doc? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( opengl )
"

RDEPEND="
	dev-cpp/pystring
	>=dev-cpp/yaml-cpp-0.7.0:=
	dev-libs/expat
	>=dev-libs/imath-3.1.5:=
	sys-libs/minizip-ng
	sys-libs/zlib
	apps? (
		media-libs/lcms:2
		>=media-libs/openexr-3.1.5:=
	)
	opengl? (
		media-libs/freeglut
		media-libs/glew:=
		media-libs/libglvnd
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	)
"
DEPEND="${RDEPEND}"
# TODO: OSL tests would need OIIO, leading to a circular dependency. If OIIO
# isn't found this test will be skipped (automagic if found?)
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-tabs[${PYTHON_USEDEP}]
			dev-python/testresources[${PYTHON_USEDEP}]
		')
	)
	opengl? (
		media-libs/freeglut
		media-libs/glew:=
		media-libs/libglvnd
	)
"
# 	test? (
# 		>=media-libs/openimageio-2.2.14
# 		>=media-libs/osl-1.11
# 	)
# "

# Restricting tests, bugs #439790 and #447908
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-adjust-python-installation.patch
	"${FILESDIR}"/${PN}-2.2.1-support-minizip-ng-4.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# Avoid automagic test dependency on OSL, bug #833933
	# Can cause problems during e.g. OpenEXR unsplitting migration
	cmake_run_in tests cmake_comment_add_subdirectory osl
}

src_configure() {
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# Notes:
	# - OpenImageIO or OpenEXR (default) is required for building ociodisplay and
	#	ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DOCIO_BUILD_APPS=$(usex apps)
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)
		-DOCIO_BUILD_GPU_TESTS=$(usex test)
		-DOCIO_BUILD_JAVA=OFF
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
		-DOCIO_USE_OIIO_CMAKE_CONFIG=ON
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
	)
	use python && mycmakeargs+=(
		-DOCIO_PYTHON_VERSION="${EPYTHON/python/}"
		-DPython_EXECUTABLE="${PYTHON}"
		-DPYTHON_VARIANT_PATH=$(python_get_sitedir)
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
