# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils eutils flag-o-matic toolchain-funcs

MYP=${P/-20/-snapshot-}

DESCRIPTION="Gerris Flow Solver"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://gerris.dalembert.upmc.fr/gerris/tarballs/${MYP}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples mpi static-libs"

# all these deps could be optional
# but the configure.in would have to be modified
# heavily for the automagic
RDEPEND="
	dev-libs/glib:2
	dev-games/ode
	sci-libs/netcdf
	sci-libs/gsl
	sci-libs/gts
	sci-libs/hypre[mpi?]
	sci-libs/lis[mpi?]
	sci-libs/proj
	>=sci-libs/fftw-3
	virtual/lapack
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

# buggy tests, need extra packages and require gerris to be installed
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-20130531-hypre-no-mpi.patch
	"${FILESDIR}"/${PN}-20130531-lis-matrix-csr.patch
	"${FILESDIR}"/${PN}-20130531-use-blas-lapack-system.patch
)

src_configure() {
	append-cppflags "-I${EPREFIX}/usr/include/hypre"
	local myeconfargs=(
		$(use_enable mpi)
	)
	autotools-utils_src_configure \
		LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/examples/*
	fi
}
