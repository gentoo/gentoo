# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit python-any-r1 toolchain-funcs cmake

MYPN="clBLAS"

DESCRIPTION="Library containing BLAS routines for OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clBLAS"
SRC_URI="https://github.com/clMathLibraries/${MYPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/2" # soname version
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+client doc examples ktest performance test"
# the testsuite is hopelessly broken and upstream is pretty much dead
RESTRICT="test"

RDEPEND="
	virtual/opencl
	client? ( virtual/cblas )
	doc? ( dev-libs/mathjax )"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	client? ( virtual/pkgconfig )"

S="${WORKDIR}/${MYPN}-${PV}"
CMAKE_USE_DIR="${S}/src"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12-disable-multilib-cflags.patch
	"${FILESDIR}"/${PN}-2.12-fix-pthread-linkage.patch
	"${FILESDIR}"/${PN}-2.12-fix-doxygen-output-dir.patch
	"${FILESDIR}"/${PN}-2.12-use-system-mathjax.patch
	"${FILESDIR}"/${PN}-2.12-reproducible-build.patch
	"${FILESDIR}"/${PN}-2.12-use-boost-dynamic-libs.patch
	"${FILESDIR}"/${PN}-2.12-Detect-CBLAS-when-building-the-client.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_RUNTIME=ON
		-DBUILD_SAMPLE=OFF
		# tests are beyond repair
		-DBUILD_TEST=OFF
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_KTEST=$(usex ktest)
		-DBUILD_PERFORMANCE=$(usex performance)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	use client && mycmakeargs+=(
		-DNetlib_LIBRARIES="$($(tc-getPKG_CONFIG) --libs cblas blas)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cd doc || die
		doxygen clBLAS.doxy || die
		HTML_DOCS=( doc/html/. )
	fi
}

src_install() {
	cmake_src_install

	dodoc CHANGELOG CONTRIBUTING.md NOTICE README.md
	if use examples; then
		docinto examples
		dodoc -r src/samples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
