# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-single-r1 virtualx

DESCRIPTION="Color management framework for visual effects and animation"
HOMEPAGE="https://opencolorio.org https://github.com/AcademySoftwareFoundation/OpenColorIO"
SRC_URI="https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
# minizip-ng: ~arm ~arm64 ~ppc64 ~riscv
# osl: ~riscv
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
CPU_USE=(
	x86_{avx,avx2,avx512f,f16c,sse2,sse3,sse4_1,sse4_2,ssse3}
	# requires https://github.com/DLTcollab/sse2neon
	# arm_neon
)
IUSE="apps ${CPU_USE[*]/#/cpu_flags_} doc opengl python test"
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
		app-text/doxygen
		$(python_gen_cond_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-press-theme[${PYTHON_USEDEP}]
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
# compares floating point numbers for bit equality
# compares floating point number string representations for equality
# https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1361 Apr 4, 2021
# https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1784 Apr 3, 2023
RESTRICT="test" #"!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.1-adjust-python-installation.patch"
	"${FILESDIR}/${PN}-2.3.2-include-cstdint.patch"
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
		"-DOCIO_BUILD_APPS=$(usex apps)"
		"-DOCIO_BUILD_DOCS=$(usex doc)"
		"-DOCIO_BUILD_FROZEN_DOCS=$(usex doc)"
		"-DOCIO_BUILD_GPU_TESTS=$(usex test)"
		"-DOCIO_BUILD_JAVA=OFF"
		"-DOCIO_BUILD_PYTHON=$(usex python)"
		"-DOCIO_BUILD_TESTS=$(usex test)"
		"-DOCIO_INSTALL_EXT_PACKAGES=NONE"
		# allow the user to tell OCIO to display more information when searching and building the dependencies.
		# "-DOCIO_VERBOSE=YES"

		"-DOCIO_USE_SIMD=ON"
	)

	if use amd64 || use x86 ; then
		mycmakeargs+=(
			"-DOCIO_USE_SSE2=$(usex cpu_flags_x86_sse2)"
			"-DOCIO_USE_SSE3=$(usex cpu_flags_x86_sse3)"
			"-DOCIO_USE_SSSE3=$(usex cpu_flags_x86_ssse3)"
			"-DOCIO_USE_SSE4=$(usex cpu_flags_x86_sse4_1)"
			"-DOCIO_USE_SSE42=$(usex cpu_flags_x86_sse4_2)"
			"-DOCIO_USE_AVX=$(usex cpu_flags_x86_avx)"
			"-DOCIO_USE_AVX2=$(usex cpu_flags_x86_avx2)"
			"-DOCIO_USE_AVX512=$(usex cpu_flags_x86_avx512f)"
			"-DOCIO_USE_F16C=$(usex cpu_flags_x86_f16c)"
		)
	fi

	# requires https://github.com/DLTcollab/sse2neon
	# if use arm || use arm64 ; then
	# 	mycmakeargs+=(
	# 		"-DOCIO_USE_SSE2NEON=$(usex cpu_flags_arm_neon)"
	# 	)
	# fi

	use python && mycmakeargs+=(
		"-DOCIO_PYTHON_VERSION=${EPYTHON/python/}"
		"-DPython_EXECUTABLE=${PYTHON}"
		"-DPYTHON_VARIANT_PATH=$(python_get_sitedir)"
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		-j1
	)
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		# there are already files in ${ED}/usr/share/doc/${PF}
		mv "${ED}/usr/share/doc/OpenColorIO/"* "${ED}/usr/share/doc/${PF}" || die
		rmdir "${ED}/usr/share/doc/OpenColorIO" || die
	fi
}
