# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Portable Understructure for Numerical Computing"
HOMEPAGE="http://fetk.org/codes/punc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug doc mpi"

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
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
	)"

PATCHES=(
	"${FILESDIR}"/${PV}-linking.patch
	"${FILESDIR}"/1.4-doc.patch
)

src_prepare() {
	sed 's:punc/slu_ddefs.h:superlu/slu_ddefs.h:g' src/superlu/punc/vsuperlu.h > vsuperlu.h || die
	sed 's:punc/umfpack.h:umfpack.h:g' src/umfpack/punc/vumfpack.h > vumfpack.h || die
	rm -r src/{amd,blas,lapack,arpack,superlu,umfpack} || die

	cp -f tools/tests/pmg/*.f src/pmg/ || die
	cp -f tools/tests/pmg/*.c src/pmg/ || die
	cp src/pmg/vpmg.h src/vf2c/punc/vpmg.h || die

	default
	eautoreconf
}

src_configure() {
	export FETK_INCLUDE="${ESYSROOT}"/usr/include
	export FETK_LIBRARY="${ESYSROOT}"/usr/$(get_libdir)

	export FETK_LAPACK_LIBRARY="$($(tc-getPKG_CONFIG) --libs lapack)"
	export FETK_BLAS_LIBRARY="${FETK_LIBRARY}"
	export FETK_SUPERLU_LIBRARY="$($(tc-getPKG_CONFIG) --libs superlu)"
	export FETK_ARPACK_LIBRARY="${FETK_LIBRARY}"
	export FETK_UMFPACK_LIBRARY="${FETK_LIBRARY}"
	export FETK_CGCODE_LIBRARY="${FETK_LIBRARY}"
	export FETK_AMD_LIBRARY="${FETK_LIBRARY}"

	econf \
		--enable-vf2cforce \
		--disable-static \
		--disable-triplet \
		--with-doxygen=$(usex doc "${BROOT}"/usr/bin/doxygen '') \
		--with-dot=$(usex doc "${BROOT}"/usr/bin/dot '') \
		$(use_enable debug vdebug)
}

src_install() {
	HTML_DOCS=( doc/index.html )
	default

	insinto /usr/include/punc
	doins v*.h

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
