# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mc/mc-1.5.ebuild,v 1.8 2015/04/21 17:41:13 pacho Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2 multilib

DESCRIPTION="2D/3D AFEM code for nonlinear geometric PDE"
HOMEPAGE="http://fetk.org/codes/mc/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="debug doc static-libs"

RDEPEND="
	dev-libs/maloc
	media-libs/sg
	sci-libs/amd
	sci-libs/gamer
	sci-libs/punc
	sci-libs/superlu
	sci-libs/umfpack
	virtual/blas
	virtual/lapack"
DEPEND="
	${RDEPEND}
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
		)"

S="${WORKDIR}"/${PN}

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
	export FETK_MPI_LIBRARY="${fetk_lib}"
	export FETK_VF2C_LIBRARY="${fetk_lib}"
	export FETK_BLAS_LIBRARY="${fetk_lib}"
	export FETK_LAPACK_LIBRARY="${fetk_lib}"
	export FETK_AMD_LIBRARY="${fetk_lib}"
	export FETK_UMFPACK_LIBRARY="${fetk_lib}"
	export FETK_SUPERLU_LIBRARY="${fetk_lib}"
	export FETK_ARPACK_LIBRARY="${fetk_lib}"
	export FETK_CGCODE_LIBRARY="${fetk_lib}"
	export FETK_PMG_LIBRARY="${fetk_lib}"

	myeconfargs+=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug vdebug)
		--disable-triplet
		--enable-shared
	)
	autotools-utils_src_configure
}
