# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED="fortran"
FORTRAN_STANDARD=90

inherit autotools cuda fortran-2 toolchain-funcs

DESCRIPTION="Unified runtime system for heterogeneous multicore architectures"
HOMEPAGE="https://starpu.gitlabpages.inria.fr/"
SRC_URI="https://files.inria.fr/${PN}/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/7"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

IUSE="
	blas cuda doc examples fftw fortran hdf5 mpi opencl opengl
	openmp spinlock-check static-libs test valgrind
"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-mathematics/glpk:0=
	>=sys-apps/hwloc-2.3.0:0=
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit
			x11-drivers/nvidia-drivers )
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( sci-libs/hdf5:0= )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/freeglut:0= )
	valgrind? ( dev-util/valgrind )
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	fortran-2_pkg_setup
}

src_prepare() {
	default

	sed -i -e '/Libs.private/s/@LDFLAGS@//g' *.pc.in */*.pc.in || die
	sed -i -e 's/-O3//g;s/-D_FORTIFY_SOURCE=1//g' configure.ac || die
	eautoreconf

	use cuda && cuda_src_prepare
}

src_configure() {
	use blas && export BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"

	econf \
		$(use mpi && use_enable test mpi-check) \
		$(use_enable cuda) \
		$(use_enable doc build-doc) \
		$(use_enable doc build-doc-pdf) \
		$(use_enable fftw starpufft) \
		$(use_enable fortran) \
		$(use_enable hdf5) \
		$(use_enable mpi) \
		$(use_enable opencl) \
		$(use_enable opengl opengl-render) \
		$(use_enable openmp) \
		$(use_enable spinlock-check) \
		$(use_enable static-libs static) \
		$(use_enable valgrind) \
		$(use_with mpi mpicc "$(type -P mpicc)") \
		--disable-build-examples \
		--disable-debug \
		--disable-fstack-protector-all \
		--disable-full-gdb-information
}

src_test() {
	# Avoids timeouts in e.g. starpu_task_wait_for_all, starpu_task_wait
	# See bug #803158
	# https://gitub.u-bordeaux.fr/starpu/starpu/-/blob/master/contrib/ci.inria.fr/job-1-check.sh
	export STARPU_TIMEOUT_ENV=3600
	export MPIEXEC_TIMEOUT=3600

	# Could switch(?) to quick check if timeouts end up being a real problem, but let's not
	# do it for now. https://gitub.u-bordeaux.fr/starpu/starpu/-/blob/master/contrib/ci.inria.fr/job-1-check.sh#L85
	MAKEOPTS='-j1' default
}

src_install() {
	default
	use doc && dodoc -r doc/doxygen/*.pdf doc/doxygen/html
	use examples && dodoc -r examples
	find "${ED}" -name '*.la' -delete || die
}
