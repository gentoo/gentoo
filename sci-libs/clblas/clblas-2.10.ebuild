# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
FORTRAN_NEEDED=test

inherit cmake-utils python-single-r1 toolchain-funcs fortran-2

MYPN="clBLAS"

DESCRIPTION="Library containing BLAS routines for OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clBLAS"
SRC_URI="https://github.com/clMathLibraries/${MYPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/2" # soname version
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+client doc examples ktest performance test"

REQUIRED_USE="performance? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/opencl
	doc? ( dev-libs/mathjax )
	performance? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
	   dev-cpp/gtest
	   dev-libs/boost
	   virtual/pkgconfig
	   virtual/blas
	)
"

S="${WORKDIR}/${MYPN}-${PV}"
CMAKE_USE_DIR="${S}/src"

PATCHES=(
	"${FILESDIR}"/${P}-disable-multilib-cflags.patch
	"${FILESDIR}"/${P}-fix-blas-dot-calls.patch
	"${FILESDIR}"/${P}-fix-doxygen-output-dir.patch
	"${FILESDIR}"/${P}-fix-pthread-linkage.patch
	"${FILESDIR}"/${P}-use-boost-dynamic-libs.patch
	"${FILESDIR}"/${P}-use-system-mathjax.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_RUNTIME=ON
		-DBUILD_SAMPLE=OFF
		-DBUILD_CLIENT="$(usex client)"
		-DBUILD_KTEST="$(usex ktest)"
		-DBUILD_PERFORMANCE="$(usex performance)"
	)
	if use test; then
		mycmakeargs+=(
			-DBUILD_TEST=ON
			-DUSE_SYSTEM_GTEST=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
		)
	else
		mycmakeargs+=( -DBUILD_TEST=OFF	)
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cd doc
		doxygen clBLAS.doxy || die
	fi
}

src_test() {
	pushd "${BUILD_DIR}/staging" > /dev/null
	LD_LIBRARY_PATH="${BUILD_DIR}/library:${LD_LIBRARY_PATH}" \
				   ./test-short
	popd > /dev/null

	# horrible hack to avoid installing compiled tests
	# this will trigger some overcompilation
	mycmakeargs+=( -DBUILD_TEST=OFF	)
	cmake-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	cmake-utils_src_install
	dodoc CHANGELOG  CONTRIBUTING.md NOTICE  README.md
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r src/samples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
