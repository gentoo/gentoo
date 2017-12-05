# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_STANDARD=90

inherit autotools toolchain-funcs cuda fortran-2

DESCRIPTION="Unified runtime system for heterogeneous multicore architectures"
HOMEPAGE="http://runtime.bordeaux.inria.fr/StarPU/"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/8"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="blas cuda debug doc examples fftw gcc-plugin mpi opencl opengl
	qt4 static-libs test"

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
			x11-libs/qwt:5 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )
	test? ( gcc-plugin? ( dev-scheme/guile ) )"

src_prepare() {
	default
	# upstream did not want the patches so apply sed's
	sed -i -e 's/-O3 $CFLAGS/$CFLAGS/' configure.ac || die
	sed -i -e '/Libs.private/s/@LDFLAGS@//g' *.pc.in */*.pc.in || die
	eautoreconf
	use cuda && cuda_src_prepare
}

src_configure() {
	use blas && export BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"

	econf \
		--disable-build-examples \
		$(use_enable cuda) \
		$(use_enable debug) \
		$(use_enable doc build-doc) \
		$(use_enable fftw starpufft) \
		$(use_enable gcc-plugin gcc-extensions) \
		$(use_enable opencl) \
		$(use_enable opengl opengl-render) \
		$(use_enable qt4 starpu-top) \
		$(use_enable static-libs static) \
		$(use_with mpi mpicc "$(type -P mpicc)") \
		$(use cuda && use_enable blas magma) \
		$(use mpi && use_enable test mpi-check)
}

src_test() {
	emake -j1 showcheck
}

src_install() {
	default
	use doc && dodoc -r doc/doxygen/*.pdf doc/doxygen/html
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
	prune_libtool_files --all
}
