# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils multilib toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="minimal? ( LGPL-2.1 ) !minimal? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cuda doc lapack metis minimal static-libs"

RDEPEND="
	>=sci-libs/amd-2.3
	>=sci-libs/colamd-2.8
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	lapack? ( virtual/lapack )
	metis? (
		>=sci-libs/camd-2.3
		>=sci-libs/ccolamd-2.8
		|| ( <sci-libs/metis-5 <sci-libs/parmetis-4 ) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_prepare() {
	# bug #399483 does not build with parmetis-3.2
	has_version "=sci-libs/parmetis-3.2*" && \
		epatch "${FILESDIR}"/${PN}-1.7.4-parmetis32.patch
}

src_configure() {
	local lapack_libs=no
	local blas_libs=no
	if use lapack; then
		blas_libs=$($(tc-getPKG_CONFIG) --libs blas)
		lapack_libs=$($(tc-getPKG_CONFIG) --libs lapack)
	fi
	local myeconfargs=(
		--with-blas="${blas_libs}"
		--with-lapack="${lapack_libs}"
		$(use_with doc)
		$(use_with !minimal modify)
		$(use_with !minimal matrixops)
		$(use_with !minimal partition)
		$(use_with metis camd)
		$(use_with metis partition)
		$(use_with lapack supernodal)
	)
	if use cuda; then
		myeconfargs+=(
			--with-cuda
			--with-cublas-libs="-L${EPREFIX}/opt/cuda/$(get_libdir) -lcublas"
			--with-cublas-cflags="-I${EPREFIX}/opt/cuda/include"
		)
	fi
	autotools-utils_src_configure
}
