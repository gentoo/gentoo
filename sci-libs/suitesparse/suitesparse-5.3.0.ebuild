# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# FIXME: currently this is a safety measure. Is it really needed by the
#	fortran modules?
FORTRAN_NEED_OPENMP=1

# FIXME: how to handle cmake without having a root CMakeLists.txt?
inherit fortran-2 toolchain-funcs

MY_PN="SuiteSparse"

DESCRIPTION="Package for a suite of sparse matrix tools"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://faculty.cse.tamu.edu/davis/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

# BSD: amd, camd, ccolamd, colamd, ssget
# LGPL-2.1+: btf, cholmod/Check, choldmod/Cholesky, cholmod/Core,
#	cholmod/Partition, cxsparse, klu, ldl
# GPL-2+: choldmod/Demo, cholmod/Matlab, cholmod/MatrixOps,
#	cholmod/Modify, cholmod/Supernodal, cholmod/Tcov, cholmod/Valgrind,
#	GPUQREngine, RBio, spqr, SuiteSparse_GPURuntime, umfpack
# Apache-2.0: GraphBLAS
# GPL-3: Mongoose
LICENSE="Apache-2.0 BSD GPL-2+ GPL-3 LGPL-2.1+"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

FORTRAN_NEEDED="amd"

# FIXME: currently not included:
#	Piro_Band, Skyline_SVD
# GraphBLAS and Mongoose are cmake based builds
# SuiteSparse_GPURuntime and GPUQREngine are part of spqr[cuda]
# FIXME: cuda is not compiling due to C/C++ mixing
# FIXME: testing
IUSE="cuda fortran tbb test"

# Tests currently fail in cholmod library
#RESTRICT="!test? ( test )"
RESTRICT="test"

# FIXME: Exclude the old packages. These could be removed once the package
# and revdeps are fully updated.
RDEPEND="
	!<sci-libs/suitesparse-5
	!sci-libs/amd
	!sci-libs/btf
	!sci-libs/camd
	!sci-libs/ccolamd
	!sci-libs/cholmod
	!sci-libs/colamd
	!sci-libs/cxsparse
	!sci-libs/klu
	!sci-libs/ldl
	!sci-libs/spqr
	!sci-libs/suitesparseconfig
	!sci-libs/umfpack
	|| ( >=sci-libs/metis-5.1.0-r3[openmp(+)] >=sci-libs/parmetis-4.0.3[openmp(+)] )
	virtual/blas:=
	virtual/lapack:=
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.2.88:=
		>=sci-libs/magma-2.4.0:=
	)
	tbb? ( >=dev-cpp/tbb-2017.20161128:= )
"

DEPEND="
	${RDEPEND}
	>=dev-util/indent-2.2.11-r1
	>=sys-apps/grep-3.1
	test? ( >=app-shells/tcsh-6.20.00 )
"

S=${WORKDIR}/${MY_PN}

PATCHES=(
	"${FILESDIR}/${P}-config.patch"
	"${FILESDIR}/${P}-Makefile.patch"
)

DOCS=( README.txt )

pkg_setup() {
	# several of the packages need openmp support, so check for it early
	tc-check-openmp || die "Need OpenMP to build ${P}"
}

src_compile() {
	local myblas=$($(tc-getPKG_CONFIG) --libs blas)
	local mylapack=$($(tc-getPKG_CONFIG) --libs lapack)
	# FIXME: AUTOCC auto-enables intel compilers
	local mymakeopts="OPTIMIZATION= AUTOCC=no"
	mymakeopts="${mymakeopts} LAPACK=\"${mylapack}\" BLAS=\"${myblas}\""
	mymakeopts="${mymakeopts} MY_METIS_LIB=-lmetis"
	if use cuda; then
		mymakeopts="${mymakeopts} CUDA=yes magma_inc=/usr magma_lib=/usr/$(get_libdir)"
	else
		mymakeopts="${mymakeopts} CUDA=no"
	fi
	if use fortran; then
		local myf77=$(tc-getF77)
		mymakeopts="${mymakeopts} F77=${myf77}"
	fi
	if use tbb; then
		mymakeopts="${mymakeopts} TBB=-ltbb SPQR_CONFIG+=-DHAVE_TBB"
	fi
	use test && mymakeopts="${mymakeopts} TCOV=yes"
	export LD_LIBRARY_PATH="${S}/lib"
	emake ${mymakeopts} config # FIXME: remove on final ebuild
	emake ${mymakeopts}
	if use fortran; then
		emake -C "${S}/AMD" fortran ${mymakeopts}
	fi
}

src_test() {
	local myblas=$($(tc-getPKG_CONFIG) --libs blas)
	local mylapack=$($(tc-getPKG_CONFIG) --libs lapack)
	local mytestargs="OPTIMIZATION= AUTOCC=no BLAS=${myblas} LAPACK=${mylapack}"
	mytestargs="${mytestargs} MY_METIS_LIB=-lmetis"
	if use cuda; then
		mytestargs="${mytestargs} CUDA=yes magma_inc=/usr magma_lib=/usr/$(get_libdir)"
	else
		mytestargs="${mytestargs} CUDA=no"
	fi
	if use fortran; then
		local myf77=$(tc-getF77)
		mytestargs="${mytestargs} F77=${myf77}"
	fi
	if use tbb; then
		mytestargs="${mytestargs} TBB=-ltbb SPQR_CONFIG+=-DHAVE_TBB"
	fi
	export LD_LIBRARY_PATH="${S}/lib"
	emake ${mytestargs} cov
}

src_install() {
	local myblas=$($(tc-getPKG_CONFIG) --libs blas)
	local mylapack=$($(tc-getPKG_CONFIG) --libs lapack)
	local myinstallargs="INSTALL=${ED%/}/usr INSTALL_LIB=${ED%/}/usr/$(get_libdir)"
	myinstallargs="${myinstallargs} BLAS=${myblas} LAPACK=${mylapack} MY_METIS_LIB=-lmetis"
	if use cuda; then
		myinstallargs="${myinstallargs} CUDA=yes magma_inc=/usr magma_lib=/usr/$(get_libdir)"
	else
		myinstallargs="${myinstallargs} CUDA=no"
	fi
	if use fortran; then
		local myf77=$(tc-getF77)
		myinstallargs="${myinstallargs} F77=${myf77}"
	fi
	if use tbb; then
		myinstallargs="${myinstallargs} TBB=-ltbb SPQR_CONFIG+=-DHAVE_TBB"
	fi
	emake ${myinstallargs} install
	if use fortran; then
		emake -C "${S}/AMD/Lib" ${myinstallargs} install-fortran
	fi
}
