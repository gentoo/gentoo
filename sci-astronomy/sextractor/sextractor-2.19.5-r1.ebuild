# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AUTOTOOLS_AUTO_DEPEND=no

inherit autotools

DESCRIPTION="Extract catalogs of sources from astronomical FITS images"
HOMEPAGE="http://www.astromatic.net/software/sextractor"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3"
SLOT="0"

IUSE="doc modelfit test threads"

RDEPEND="
	!games-misc/sex
	modelfit? ( sci-libs/atlas[lapack,threads=] sci-libs/fftw:3.0 )"
DEPEND="${RDEPEND}
	modelfit? ( ${AUTOTOOLS_DEPEND} )"

REQUIRED_USE="test? ( modelfit )"

PATCHES=(
	"${FILESDIR}/${P}-fix-format-errors.patch"
	"${FILESDIR}/${P}-have-malloc.patch"
	"${FILESDIR}/${P}-have-mmap.patch"
	"${FILESDIR}/${P}-sigbus.patch"
)

src_prepare() {
	default
	if use modelfit; then
	local mycblas=atlcblas myclapack=atlclapack
	if use threads; then
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptcblas.so ]] && \
			mycblas=ptcblas
		[[ -e "${EPREFIX}"/usr/$(get_libdir)/libptclapack.so ]] && \
			myclapack=ptclapack
	fi
	sed -i \
		-e "s/-lcblas/-l${mycblas}/g" \
		-e "s/AC_CHECK_LIB(cblas/AC_CHECK_LIB(${mycblas}/g" \
		-e "s/-llapack/-l${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		acx_atlas.m4 || die
	eautoreconf
	fi
}

src_configure() {
	econf \
		--with-atlas-incdir="${EPREFIX}/usr/include/atlas" \
		$(use_enable modelfit model-fitting) \
		$(use_enable threads)
}

src_install () {
	default
	CONFDIR=/usr/share/sextractor
	insinto ${CONFDIR}
	doins config/*
	use doc && dodoc doc/*
}

pkg_postinst() {
	elog "SExtractor examples configuration files are located in"
	elog "${EROOT%/}/${CONFDIR} and are not loaded anymore by default."
}
