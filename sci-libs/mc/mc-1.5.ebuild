# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="2D/3D AFEM code for nonlinear geometric PDE"
HOMEPAGE="http://fetk.org/codes/mc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"

RDEPEND="
	dev-libs/maloc
	media-libs/sg
	sci-libs/amd
	sci-libs/gamer
	sci-libs/punc
	<sci-libs/superlu-5
	sci-libs/umfpack
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
	)"

PATCHES=(
	"${FILESDIR}"/1.4-superlu.patch
	"${FILESDIR}"/1.4-overflow.patch
	"${FILESDIR}"/1.4-multilib.patch
	"${FILESDIR}"/1.4-doc.patch
	"${FILESDIR}"/${P}-unbundle.patch
)

src_prepare() {
	sed \
		-e 's:AMD_order:amd_order:g' \
		-e 's:UMFPACK_numeric:umfpack_di_numeric:g' \
		-e 's:buildg_:matvec_:g' \
		-i configure.ac || die

	default
	eautoreconf
}

src_configure() {
	export FETK_INCLUDE="${ESYSROOT}"/usr/include
	export FETK_LIBRARY="${ESYSROOT}"/usr/$(get_libdir)

	export FETK_MPI_LIBRARY="${FETK_LIBRARY}"
	export FETK_VF2C_LIBRARY="${FETK_LIBRARY}"
	export FETK_BLAS_LIBRARY="${FETK_LIBRARY}"
	export FETK_LAPACK_LIBRARY="${FETK_LIBRARY}"
	export FETK_AMD_LIBRARY="${FETK_LIBRARY}"
	export FETK_UMFPACK_LIBRARY="${FETK_LIBRARY}"
	export FETK_SUPERLU_LIBRARY="${FETK_LIBRARY}"
	export FETK_ARPACK_LIBRARY="${FETK_LIBRARY}"
	export FETK_CGCODE_LIBRARY="${FETK_LIBRARY}"
	export FETK_PMG_LIBRARY="${FETK_LIBRARY}"

	econf \
		--disable-static \
		--disable-triplet \
		--with-doxygen=$(usex doc "${BROOT}"/usr/bin/doxygen '') \
		--with-dot=$(usex doc "${BROOT}"/usr/bin/dot '') \
		$(use_enable debug vdebug)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
