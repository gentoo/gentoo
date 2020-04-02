# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="minimal? ( LGPL-2.1 ) !minimal? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cuda doc lapack metis minimal static-libs"

# doesn't build against current version of sci-libs/amd, sci-libs/colamd
# <sci-libs/parmetis-4 is no longer in the tree
RDEPEND="
	=sci-libs/amd-2.3*
	=sci-libs/colamd-2.8*
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	lapack? ( virtual/lapack )
	metis? (
		=sci-libs/camd-2.3*
		>=sci-libs/ccolamd-2.8
		<sci-libs/metis-5 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}/${P}-0001-Gentoo-specific-fix-self-linking-of-files.patch"
)

src_prepare() {
	default
	eautoreconf
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
	econf "${myeconfargs[@]}"
}

src_compile() {
	use doc && export VARTEXFONTS="${T}/fonts"
	default
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die "failed to delete static libs"
		find "${ED}" -name '*.la' -delete || die "failed to delete libtool files"
	fi
}
