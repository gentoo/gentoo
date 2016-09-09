# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

MY_P=${P/-20/-snapshot-}

DESCRIPTION="Gerris Flow Solver"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://gerris.dalembert.upmc.fr/gerris/tarballs/${MY_P}.tar.gz"

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
	sci-libs/netcdf:=
	sci-libs/gsl:=
	sci-libs/gts
	sci-libs/hypre[mpi?]
	sci-libs/lis[mpi?]
	sci-libs/proj
	sci-libs/fftw:3.0=
	virtual/lapack
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

# buggy tests, need extra packages and require gerris to be installed
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-20130531-hypre-no-mpi.patch
	"${FILESDIR}"/${PN}-20130531-lis-matrix-csr.patch
	"${FILESDIR}"/${PN}-20130531-use-blas-lapack-system.patch
	"${FILESDIR}"/${PN}-20131206-lis-api-change.patch
	"${FILESDIR}"/${PN}-20131206-DEFAULT_SOURCE-replacement.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags "-I${EPREFIX}/usr/include/hypre"
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable mpi) \
		LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_install() {
	default
	use examples && dodoc -r doc/examples

	find "${D}" -name '*.la' -delete || die
}
