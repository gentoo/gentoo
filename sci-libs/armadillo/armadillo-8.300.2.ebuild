# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1

inherit cmake-utils toolchain-funcs multilib eutils

DESCRIPTION="Streamlined C++ linear algebra library"
HOMEPAGE="http://arma.sourceforge.net/"
SRC_URI="mirror://sourceforge/arma/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0/8"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="arpack blas debug doc examples hdf5 lapack mkl superlu tbb test"
REQUIRED_USE="test? ( lapack )"

#	atlas? ( sci-libs/atlas[lapack] )

RDEPEND="
	dev-libs/boost
	arpack? ( sci-libs/arpack )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )
	superlu? ( >=sci-libs/superlu-5.2 )
"

DEPEND="${RDEPEND}
	arpack? ( virtual/pkgconfig )
	blas? ( virtual/pkgconfig )
	hdf5? ( sci-libs/hdf5 )
	lapack? ( virtual/pkgconfig )
	mkl? ( sci-libs/mkl )
	tbb? ( dev-cpp/tbb )"
PDEPEND="${RDEPEND}
	hdf5? ( sci-libs/hdf5 )
	mkl? ( sci-libs/mkl )
	tbb? ( dev-cpp/tbb )"

src_prepare() {
	# avoid the automagic cmake macros
	sed -i -e '/ARMA_Find/d' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DARMA_EXTRA_DEBUG="$(usex debug)"
		-DARMA_USE_MKL_ALLOC="$(usex mkl)"
		-DARMA_USE_TBB_ALLOC="$(usex tbb)"
	)
	if use arpack; then
		mycmakeargs+=(
			-DARPACK_FOUND=ON
			-DARPACK_LIBRARY="$($(tc-getPKG_CONFIG) --libs arpack)"
		)
	else
		mycmakeargs+=(
			-DARPACK_FOUND=OFF
		)
	fi
#	if use atlas; then
#		local c=atlas-cblas l=atlas-clapack
#		$(tc-getPKG_CONFIG) --exists ${c}-threads && c+=-threads
#		$(tc-getPKG_CONFIG) --exists ${l}-threads && l+=-threads
#		mycmakeargs+=(
#			-DCBLAS_FOUND=ON
#			-DCBLAS_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --cflags-only-I ${c} | sed 's/-I//')"
#			-DCBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${c})"
#			-DCLAPACK_FOUND=ON
#			-DCLAPACK_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --cflags-only-I ${l} | sed 's/-I//')"
#			-DCLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${l})"
#		)
#	fi
	if use blas; then
		mycmakeargs+=(
			-DBLAS_FOUND=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
		)
	else
		mycmakeargs+=(
			-DBLAS_FOUND=OFF
		)
	fi
	if use hdf5; then
		mycmakeargs+=(
			-DHDF5_FOUND=ON
			-DHDF5_LIBRARIES="-lhdf5"
		)
	else
		mycmakeargs+=(
			-DHDF5_FOUND=OFF
		)
	fi
	if use lapack; then
		mycmakeargs+=(
			-DLAPACK_FOUND=ON
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
		)
	else
		mycmakeargs+=(
			-DLAPACK_FOUND=OFF
		)
	fi
	if use superlu; then
		mycmakeargs+=(
			-DSuperLU_FOUND=ON
			-DSuperLU_LIBRARY="$($(tc-getPKG_CONFIG) --libs superlu)"
			-DSuperLU_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --cflags-only-I superlu | awk '{print $1}' | sed 's/-I//')"
		)
	else
		mycmakeargs+=(
			-DSuperLU_FOUND=OFF
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	pushd examples > /dev/null
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="-I../include ${CXXFLAGS} -DARMA_USE_BLAS -DARMA_USE_LAPACK" \
		LIB_FLAGS="-L.. -larmadillo $($(tc-getPKG_CONFIG) --libs blas lapack)"
	LD_LIBRARY_PATH="..:${LD_LIBRARY_PATH}" ./example1 || die
	emake clean
	popd > /dev/null
}

src_install() {
	cmake-utils_src_install
	dodoc README.txt
	use doc && dodoc *pdf *html
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
