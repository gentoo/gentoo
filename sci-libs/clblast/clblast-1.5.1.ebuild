# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

MYPN="CLBlast"

DESCRIPTION="Tuned OpenCL BLAS"
HOMEPAGE="https://github.com/CNugteren/CLBlast"
SRC_URI="https://github.com/CNugteren/CLBlast/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client doc examples +persistent test"
RESTRICT="!test? ( test )"

DEPEND="virtual/opencl"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( || (
		sci-libs/mkl
		virtual/cblas
	) )
"
S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	# no forced optimisation, libdir
	sed -e 's/-O3//g' -e 's/-O2//g' \
		-e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g' \
		-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DVERBOSE=ON
		-DSAMPLES=OFF
		-DTUNERS=ON
		-DOPENCL=ON
		-DCUDA=OFF
		-DNETLIB=ON
		-DNETLIB_PERSISTENT_OPENCL=$(usex persistent)
		-DCLIENTS="$(usex client)"
		-DTESTS="$(usex test)"
	)

	if use test || use client; then
		mycmakeargs+=(
			-DCBLAS_ROOT="${ESYSROOT}"
		)
	fi
	cmake_src_configure
}

src_test() {
	cmake_src_test alltests
}

src_install() {
	cmake_src_install
	dodoc README.md CONTRIBUTING.md CHANGELOG
	use doc && dodoc -r doc
	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc -r samples/.
	fi
}
