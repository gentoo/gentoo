# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake fortran-2 python-single-r1

# package id: changes every version, see the link on inriaforge
PID=38205
DESCRIPTION="Parallel solver for very large sparse linear systems"
HOMEPAGE="https://pastix.gforge.inria.fr"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/${PID}/${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda examples +fortran int64 metis mpi +python +scotch starpu test"

RESTRICT="!test? ( test )"

# REQUIRED_USE explanation:
# 1. Not a typo, Python is needed at build time regardless of whether
#    the bindings are to be installed or not
# 2. While not enforced by upstream build scripts, having no ordering at all
#    results in rather spectacular test and runtime failures.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( metis scotch )"

RDEPEND="sys-apps/hwloc:0=
	virtual/blas
	virtual/cblas
	virtual/lapack
	virtual/lapacke
	cuda? ( dev-util/nvidia-cuda-toolkit )
	metis? ( sci-libs/metis[int64?] )
	mpi? ( virtual/mpi[fortran] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		')
	)
	scotch? ( sci-libs/scotch:0=[int64?,mpi?] )
	starpu? ( >=dev-libs/starpu-1.3.0:0= )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( ${RDEPEND} )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.3-cmake-installdirs.patch
	"${FILESDIR}"/${PN}-6.0.3-cmake-examples-optional.patch
	"${FILESDIR}"/${PN}-6.0.3-cmake-python-optional.patch
	"${FILESDIR}"/${PN}-6.0.3-cmake-spm-project.patch
	"${FILESDIR}"/${PN}-6.0.3-multiple-coeftabMemory.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=yes
		-DINSTALL_EXAMPLES=$(usex examples)
		-DPASTIX_INT64=$(usex int64)
		-DPASTIX_ORDERING_METIS=$(usex metis)
		-DPASTIX_ORDERING_SCOTCH=$(usex scotch)
		-DPASTIX_WITH_CUDA=$(usex cuda)
		-DPASTIX_WITH_FORTRAN=$(usex fortran)
		-DPASTIX_WITH_MPI=$(usex mpi)
		-DPASTIX_WITH_PYTHON=$(usex python)
		-DPASTIX_WITH_STARPU=$(usex starpu)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use python && python_optimize
}
