# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Object-oriented Scientific Computing Library"
HOMEPAGE="https://web.utk.edu/~asteine1/o2scl/"
SRC_URI="https://github.com/awsteiner/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="armadillo debug doc examples eigen fftw gsl hdf5 openmp readline static-libs"

RDEPEND="
	dev-libs/boost:=
	>=sci-libs/gsl-2:0=
	virtual/cblas:=
	eigen? ( dev-cpp/eigen:3 )
	armadillo? ( sci-libs/armadillo[lapack] )
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( sci-libs/hdf5:0= )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp && ! tc-check-openmp; then
		ewarn "OpenMP is not available in your current selected compiler"
		die "need openmp capable compiler"
	fi
}

src_configure() {
	use debug || append-cppflags -DO2SCL_NO_RANGE_CHECK
	econf \
		--enable-acol \
		$(use_enable armadillo) \
		$(use_enable eigen) \
		$(use_enable fftw) \
		$(use_enable gsl gsl2) \
		$(use_enable hdf5 hdf) \
		$(use_enable hdf5 partlib) \
		$(use_enable hdf5 eoslib) \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	rm -r "${ED}"/usr/doc || die
	if use doc; then
		dodoc -r doc/o2scl/html
		docompress -x /usr/share/doc/${PF}/html
	fi
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
