# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils toolchain-funcs cuda

DESCRIPTION="Unified runtime system for heterogeneous multicore architectures"
HOMEPAGE="http://runtime.bordeaux.inria.fr/StarPU/"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="blas cuda debug doc examples fftw gcc-plugin mpi opencl opengl qt4
	static-libs test"

RDEPEND="
	sys-apps/hwloc:0=
	sci-mathematics/glpk:0=
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit
			x11-drivers/nvidia-drivers
			blas? ( sci-libs/magma ) )
	fftw? ( sci-libs/fftw:3.0= )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/freeglut:0= )
	qt4? (  >=dev-qt/qtgui-4.7:4
			>=dev-qt/qtopengl-4.7:4
			>=dev-qt/qtsql-4.7:4
			x11-libs/qwt )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )
	test? ( gcc-plugin? ( dev-scheme/guile ) )"

src_prepare() {
	# upstream did not want the patches so apply sed's
	sed -i -e 's/-O3 $CFLAGS/$CFLAGS/' configure.ac || die
	sed -i -e '/Libs.private/s/@LDFLAGS@//g' *.pc.in */*.pc.in || die
	autotools-utils_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	use blas && export BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"

	local myeconfargs=(
		--disable-build-examples
		$(use_enable cuda)
		$(use_enable debug)
		$(use_enable doc build-doc)
		$(use_enable fftw starpufft)
		$(use_enable gcc-plugin gcc-extensions)
		$(use_enable opencl)
		$(use_enable opengl opengl-render)
		$(use_enable qt4 starpu-top)
		$(use_with mpi mpicc "$(type -P mpicc)")
		$(use cuda && use_enable blas magma)
		$(use mpi && use_enable test mpi-check)
	)
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test -j1 showcheck
}

src_install() {
	autotools-utils_src_install
	if use doc; then
		dodoc "${BUILD_DIR}"/doc/doxygen/*.pdf
		dohtml -r "${BUILD_DIR}"/doc/doxygen/html/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
