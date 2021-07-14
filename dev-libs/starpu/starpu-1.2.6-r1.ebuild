# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
FORTRAN_STANDARD=90
FORTRAN_NEEDED="fortran"
inherit autotools cuda fortran-2 toolchain-funcs

DESCRIPTION="Unified runtime system for heterogeneous multicore architectures"
HOMEPAGE="http://starpu.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/37744/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

IUSE="
	blas cuda doc examples fftw fortran gcc-plugin mpi opencl opengl
	spinlock-check static-libs test valgrind
"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-mathematics/glpk:0=
	sys-apps/hwloc:0=
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit
			x11-drivers/nvidia-drivers )
	fftw? ( sci-libs/fftw:3.0= )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/freeglut:0= )
	valgrind? ( dev-util/valgrind )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )
	test? ( gcc-plugin? ( dev-scheme/guile ) )
"

src_prepare() {
	default

	sed -i -e '/Libs.private/s/@LDFLAGS@//g' *.pc.in */*.pc.in || die
	sed -i -e 's:-O3::g;s:-D_FORTIFY_SOURCE=1::g' configure.ac || die
	eautoreconf

	use cuda && cuda_src_prepare
}

src_configure() {
	use blas && export BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"

	econf \
		--disable-magma \
		$(use mpi && use_enable test mpi-check) \
		$(use_enable cuda) \
		$(use_enable doc build-doc) \
		$(use_enable fftw starpufft) \
		$(use_enable fortran) \
		$(use_enable gcc-plugin gcc-extensions) \
		$(use_enable opencl) \
		$(use_enable opengl opengl-render) \
		$(use_enable spinlock-check) \
		$(use_enable static-libs static) \
		$(use_enable valgrind) \
		$(use_with mpi mpicc "$(type -P mpicc)") \
		--disable-build-examples \
		--disable-debug \
		--disable-fstack-protector-all \
		--disable-full-gdb-information \
		--disable-starpu-top
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
	find "${ED}" -name '*.la' -delete || die
}
