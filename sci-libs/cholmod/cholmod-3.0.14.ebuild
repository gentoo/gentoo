# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="cuda doc +lapack +matrixops +modify +partition"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="
	sci-libs/amd
	sci-libs/colamd
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)
	lapack? ( virtual/lapack )
	partition? (
		sci-libs/camd
		sci-libs/ccolamd
		>=sci-libs/metis-5.1.0
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.14-fix-CUDA.patch"
)

src_prepare() {
	use cuda && cuda_src_prepare

	default
}

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
		--disable-static \
		--with-blas="${blas_libs}" \
		--with-lapack="${lapack_libs}" \
		$(use_with doc) \
		$(use_with modify) \
		$(use_with matrixops) \
		$(use_with partition) \
		$(use_with partition camd) \
		$(use_with lapack supernodal) \
		"${cudaconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
