# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cuda doc +lapack +matrixops +modify +partition static-libs"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="
	>=sci-libs/amd-2.4
	>=sci-libs/colamd-2.9
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	lapack? ( virtual/lapack )
	partition? (
		>=sci-libs/camd-2.4
		>=sci-libs/ccolamd-2.9
		|| ( >=sci-libs/metis-5.1.0 sci-libs/parmetis ) )"
RDEPEND="${DEPEND}"

src_configure() {
	local lapack_libs=no
	local blas_libs=no
	if use lapack; then
		blas_libs=$($(tc-getPKG_CONFIG) --libs blas)
		lapack_libs=$($(tc-getPKG_CONFIG) --libs lapack)
	fi

	local cudaconfargs=( $(use_with cuda) )
	if use cuda ; then
		cudaconfargs+=(
			--with-cublas-libs="-L${EPREFIX}/opt/cuda/$(get_libdir) -lcublas"
			--with-cublas-cflags="-I${EPREFIX}/opt/cuda/include"
		)
	fi

	econf \
		--with-blas="${blas_libs}" \
		--with-lapack="${lapack_libs}" \
		$(use_with doc) \
		$(use_enable static-libs static) \
		$(use_with modify) \
		$(use_with matrixops) \
		$(use_with partition) \
		$(use_with partition camd) \
		$(use_with lapack supernodal) \
		"${cudaconfargs[@]}"
}
