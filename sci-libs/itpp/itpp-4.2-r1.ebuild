# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/itpp/itpp-4.2-r1.ebuild,v 1.15 2013/02/21 21:30:40 jlec Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic toolchain-funcs

DESCRIPTION="C++ library of mathematical, signal processing and communication"
HOMEPAGE="http://itpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="blas debug doc fftw lapack minimal static-libs"

RDEPEND="
	blas? ( virtual/blas lapack? ( virtual/lapack ) )
	!minimal? ( fftw? ( >=sci-libs/fftw-3 ) )"
DEPEND="${RDEPEND}
	blas? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen virtual/latex-base )
	lapack? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.7-fastica-fix-endless-loop.patch
	"${FILESDIR}"/${P}-fastica-correct-dim.patch
	"${FILESDIR}"/${P}-test-fftw.patch
	)

src_prepare() {
	# turn off performance critical debug code
	use debug || append-cppflags -DNDEBUG
	sed \
		-e 's:-pipe::g' \
		-e 's:-Werror::g' \
		-i configure* || die
	autotools-utils_src_prepare
}

src_configure() {
	local blasconf="no"
	use blas && blasconf="$($(tc-getPKG_CONFIG) --libs blas)"
	local lapackconf="no"
	use lapack && lapackconf="$($(tc-getPKG_CONFIG) --libs blas lapack)"

	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--enable-shared
		$(use_enable doc html-doc)
		$(use_enable debug)
		$(use_enable !minimal comm)
		$(use_enable !minimal fixed)
		$(use_enable !minimal optim)
		$(use_enable !minimal protocol)
		$(use_enable !minimal signal)
		$(use_enable !minimal srccode)
		$(use_with fftw fft)
		--with-blas="${blasconf}"
		--with-lapack="${lapackconf}"
	)
	autotools-utils_src_configure
}
