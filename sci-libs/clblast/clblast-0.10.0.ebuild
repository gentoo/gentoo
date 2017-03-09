# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs

MYPN="CLBlast"

DESCRIPTION="Tuned OpenCL BLAS"
HOMEPAGE="https://github.com/CNugteren/CLBlast"
SRC_URI="https://github.com/CNugteren/${MYPN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="client doc examples test"

RDEPEND="virtual/opencl"
DEPEND="${RDEPEND}
	test? (
	  virtual/cblas
	  virtual/pkgconfig
	)
"
S="${WORKDIR}/${MYPN}-${PV}"

src_prepare() {
	# no forced optimisation, libdir
	sed -e 's/-O3//g' \
		-e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g' \
		-i CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DSAMPLES=OFF
		-DCLIENTS="$(usex client)"
		-DTESTS="$(usex test)"
	)
	if use test || use client; then
		mycmakeargs+=(
			-DNETLIB=ON
			-DCBLAS_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) --cflags-only-I cblas| awk '{print $1}' | sed 's/-I//')"
			-DCBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs cblas)"
			-DREF_LIBRARIES="$($(tc-getPKG_CONFIG) --libs cblas)"
		)
	fi
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test alltests
}

src_install(){
	cmake-utils_src_install
	dodoc README.md CONTRIBUTING.md CHANGELOG
	use doc && dodoc -r doc
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
