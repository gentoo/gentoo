# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Extracts models of the Point Spread Function from FITS images"
HOMEPAGE="http://www.astromatic.net/software/psfex"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc threads plplot"

RDEPEND="
	sci-libs/atlas:0[lapack,threads=]
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-have-mmap.patch"
	"${FILESDIR}/${P}-plplot510.patch"
	"${FILESDIR}/${P}-sigbus.patch"
)

src_prepare() {
	default
	local mycblas=atlcblas  myclapack=atlclapack
	if use threads; then
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptcblas.so ]] && \
			mycblas=ptcblas
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptclapack.so ]] &&
		myclapack=ptclapack
	fi
	# fix the configure and not the acx_atlas.m4. the eautoreconf will
	# produce a configure giving  a wrong install Makefile target (to fix)
	sed -e "s/-lcblas/-l${mycblas}/g" \
		-e "s/AC_CHECK_LIB(cblas/AC_CHECK_LIB(${mycblas}/g" \
		-e "s/-llapack/-l${myclapack}/g" \
		-e "s/\(lapack_lib=\).*/\1${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		-i acx_atlas.m4 || die

	# fix for newer plplot
	sed -e 's/plplotd/plplot/g' -i acx_plplot.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas" \
		$(use_enable plplot) \
		$(use_enable threads)
}

src_install () {
	default
	use doc && dodoc doc/*
}
