# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{10..13} )
FORTRAN_NEEDED=fortran
inherit cmake distutils-r1 fortran-2 toolchain-funcs

DESCRIPTION="Spglib is a C library for finding and handling crystal symmetries"
HOMEPAGE="https://github.com/spglib/spglib/"
SRC_URI="https://github.com/spglib/spglib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="fortran openmp python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			dev-python/typing-extensions[${PYTHON_USEDEP}]
		' 3.10 3.11 3.12)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
		test? ( $(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]') )
	)
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.0-pyproject.patch
	"${FILESDIR}"/${PN}-2.6.0-dist_sources.patch
)

distutils_enable_tests pytest

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use fortran && fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DSPGLIB_SHARED_LIBS=ON
		-DSPGLIB_USE_OMP="$(usex openmp)"
		-DSPGLIB_WITH_Fortran="$(usex fortran)"
		-DSPGLIB_WITH_Python="$(usex python)"
		-DSPGLIB_WITH_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use python && distutils-r1_src_compile
}

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}"
	cmake_src_test
	use python && distutils-r1_src_test
}

src_install() {
	cmake_src_install
	if use python; then
		distutils-r1_src_install

		# remove duplicate headers/lib
		rm -r "${ED}"/$(python_get_sitedir)/spglib/{$(get_libdir),include} || die
	fi
}
