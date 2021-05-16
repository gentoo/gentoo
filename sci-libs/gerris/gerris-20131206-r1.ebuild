# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs xdg

MY_P=${P/-20/-snapshot-}

DESCRIPTION="Gerris Flow Solver"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="http://gerris.dalembert.upmc.fr/gerris/tarballs/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

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
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# buggy tests, need extra packages and require gerris to be installed
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-20130531-hypre-no-mpi.patch
	"${FILESDIR}"/${PN}-20130531-lis-matrix-csr.patch
	"${FILESDIR}"/${PN}-20130531-use-blas-lapack-system.patch
	"${FILESDIR}"/${PN}-20131206-lis-api-change.patch
	"${FILESDIR}"/${PN}-20131206-DEFAULT_SOURCE-replacement.patch
	"${FILESDIR}"/${PN}-20131206-slibtool.patch
	"${FILESDIR}"/${PN}-20131206-respect-NM.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #725450
	tc-export NM

	append-cppflags "-I${ESYSROOT}/usr/include/hypre"

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
