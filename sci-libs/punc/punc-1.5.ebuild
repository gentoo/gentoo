# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils fortran-2 multilib toolchain-funcs

DESCRIPTION="Portable Understructure for Numerical Computing"
HOMEPAGE="http://fetk.org/codes/punc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug doc mpi static-libs"

RDEPEND="
	dev-libs/maloc[mpi=]
	dev-libs/libf2c
	sci-libs/amd
	sci-libs/cgcode
	sci-libs/arpack[mpi=]
	sci-libs/superlu
	sci-libs/umfpack
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		app-doc/doxygen )"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-linking.patch
	"${FILESDIR}"/1.4-doc.patch
	)

src_prepare() {
	sed 's:punc/slu_ddefs.h:superlu/slu_ddefs.h:g' src/superlu/punc/vsuperlu.h > vsuperlu.h || die
	sed 's:punc/umfpack.h:umfpack.h:g' src/umfpack/punc/vumfpack.h > vumfpack.h || die
	rm -rf src/{amd,blas,lapack,arpack,superlu,umfpack}

	cp tools/tests/pmg/*.f src/pmg/ -f || die
	cp tools/tests/pmg/*.c src/pmg/ -f || die
	cp src/pmg/vpmg.h src/vf2c/punc/vpmg.h || die

	autotools-utils_src_prepare
}

src_configure() {
	local fetk_include
	local fetk_lib
	local myeconfargs

	use doc || myeconfargs+=( --with-doxygen= --with-dot= )

	fetk_include="${EPREFIX}"/usr/include
	fetk_lib="${EPREFIX}"/usr/$(get_libdir)
	export FETK_INCLUDE="${fetk_include}"
	export FETK_LIBRARY="${fetk_lib}"
	export FETK_LAPACK_LIBRARY="$($(tc-getPKG_CONFIG) --libs lapack)"
	export FETK_BLAS_LIBRARY="${fetk_lib}"
	export FETK_SUPERLU_LIBRARY="$($(tc-getPKG_CONFIG) --libs superlu)"
	export FETK_ARPACK_LIBRARY="${fetk_lib}"
	export FETK_UMFPACK_LIBRARY="${fetk_lib}"
	export FETK_CGCODE_LIBRARY="${fetk_lib}"
	export FETK_AMD_LIBRARY="${fetk_lib}"

	myeconfargs+=(
		$(use_enable debug vdebug)
		--enable-vf2cforce
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--disable-triplet
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	insinto /usr/include/punc
	doins v*.h

	dohtml doc/index.html
}
