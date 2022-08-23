# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="https://opencolorio.org https://github.com/AcademySoftwareFoundation/OpenColorIO"
SRC_URI="https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
# TODO: drop .1 on next SONAME bump (2.1 -> 2.2?) as we needed to nudge it
# to force rebuild of consumers due to changing to openexr 3 changing API.
SLOT="0/$(ver_cut 1-2).1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs test"
REQUIRED_USE="
	doc? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# Works with older OIIO but need to force a version w/ OpenEXR 3
RDEPEND="
	dev-cpp/pystring
	dev-python/pybind11
	>=dev-cpp/yaml-cpp-0.7.0:=
	>=dev-libs/imath-3.1.4-r2:=
	dev-libs/tinyxml
	opengl? (
		media-libs/lcms:2
		>=media-libs/openimageio-2.3.12.0-r3:=
		media-libs/glew:=
		media-libs/freeglut
		virtual/opengl
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/testresources[${PYTHON_USEDEP}]
		')
	)
"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1-gcc12.patch
	"${FILESDIR}"/${PN}-2.1.2-musl-strtol.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i -e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)|g" {,src/bindings/python/,src/OpenColorIO/,src/libutils/oiiohelpers/,src/libutils/oglapphelpers/}CMakeLists.txt || die
	sed -i -e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)|g" {,src/bindings/python/,src/OpenColorIO/,src/libutils/oiiohelpers/,src/libutils/oglapphelpers/}CMakeLists.txt || die

	# Avoid automagic test dependency on OSL, bug #833933
	# Can cause problems during e.g. OpenEXR unsplitting migration
	cmake_run_in tests cmake_comment_add_subdirectory osl
}

src_configure() {
	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE opengl)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE opengl)
	local mycmakeargs=(
		-DOCIO_USE_OPENEXR_HALF=OFF

		-DBUILD_SHARED_LIBS=ON
		-DOCIO_BUILD_STATIC=$(usex static-libs)
		-DOCIO_BUILD_DOCS=$(usex doc)
		-DOCIO_BUILD_APPS=$(usex opengl)
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_PYTHON_VERSION="${EPYTHON/python/}"
		-DOCIO_BUILD_JAVA=OFF
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DOCIO_BUILD_GPU_TESTS=$(usex test)
		-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
	)

	# We need this to work around asserts that can trigger even in proper use cases.
	# See https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1235
	append-flags -DNDEBUG

	cmake_src_configure
}
