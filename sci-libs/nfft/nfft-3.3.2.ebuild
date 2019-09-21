# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="library for nonequispaced discrete Fourier transformations"
HOMEPAGE="https://www-user.tu-chemnitz.de/~potts/nfft/"
SRC_URI="https://github.com/NFFT/nfft/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc openmp static-libs"

RDEPEND="sci-libs/fftw:3.0[threads,openmp?]"
DEPEND="${RDEPEND}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		if ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected compiler"

			if tc-is-clang; then
				ewarn "OpenMP support in sys-devel/clang is provided by sys-libs/libomp,"
				ewarn "which you will need to build ${CATEGORY}/${PN} with USE=\"openmp\""
			fi

			die "need openmp capable compiler"
		fi
	fi
}

src_configure() {
	econf \
	    --enable-all \
		--enable-shared \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use doc || rm -r "${ED}/usr/share/doc/${P}/html" || die

	# infft uses pkg-config to record its private dependencies
	find "${ED}" -name '*.la' -delete || die
}
