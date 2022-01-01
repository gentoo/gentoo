# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="https://opencolorio.org/"
SRC_URI="https://github.com/imageworks/OpenColorIO/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="cpu_flags_x86_sse2 doc opengl python static-libs test"
REQUIRED_USE="
	doc? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-cpp/yaml-cpp-0.5
	dev-libs/tinyxml
	opengl? (
		media-libs/lcms:2
		media-libs/openimageio
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
		')
	)
"

# Restricting tests, bugs #439790 and #447908
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-use-GNUInstallDirs-and-fix-cmake-install-location.patch"
	"${FILESDIR}/${PN}-1.1.0-remove-building-of-bundled-programs.patch"
	"${FILESDIR}/${PN}-1.1.0-yaml-cpp-0.6.patch"
	"${FILESDIR}/${PN}-1.1.0-remove-Werror.patch"
	"${FILESDIR}/${PN}-1.1.1-yaml-cpp-boost-check.patch"
	"${FILESDIR}/${P}-fix-self-assign-clang.patch"
	"${FILESDIR}/${P}-no-werror.patch"
)

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
	)

	use doc && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_LATEX=ON ) # broken
	cmake_src_configure
}
