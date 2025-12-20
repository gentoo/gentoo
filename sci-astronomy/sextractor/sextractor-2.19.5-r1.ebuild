# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTO_DEPEND=no

inherit autotools

DESCRIPTION="Extract catalogs of sources from astronomical FITS images"
HOMEPAGE="http://www.astromatic.net/software/sextractor"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc modelfit test threads"
REQUIRED_USE="test? ( modelfit )"
RESTRICT="!test? ( test )"

RDEPEND="
	!games-misc/sex
	modelfit? (
		sci-libs/atlas[lapack,threads=]
		sci-libs/fftw:3.0=
	)"
DEPEND="${RDEPEND}
	modelfit? ( ${AUTOTOOLS_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-format-errors.patch
	"${FILESDIR}"/${P}-have-malloc.patch
	"${FILESDIR}"/${P}-have-mmap.patch
	"${FILESDIR}"/${P}-sigbus.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	if use modelfit; then
		local mycblas=atlcblas
		local myclapack=atlclapack
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
		--with-atlas-incdir="${EPREFIX}"/usr/include/atlas \
		$(use_enable modelfit model-fitting) \
		$(use_enable threads)
}

src_install() {
	default

	insinto /usr/share/sextractor
	doins -r config/.
	use doc && dodoc -r doc/.
}

pkg_postinst() {
	elog "SExtractor examples configuration files are located in"
	elog "${EROOT}/usr/share/sextractor and are not loaded anymore by default."
}
