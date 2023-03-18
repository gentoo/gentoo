# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://nco.sf.net/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="dap gsl hdf5 ncap2 openmp static-libs test udunits"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-libs/netcdf-4:=[dap=,hdf5?,tools(+)]
	gsl? ( sci-libs/gsl:= )
	ncap2? ( dev-cpp/antlr-cpp:2= )
	udunits? ( >=sci-libs/udunits-2 )"
DEPEND="${RDEPEND}
	test? ( >=sci-libs/netcdf-4[tools(+)] )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	use hdf5 && append-cppflags -DHAVE_NETCDF4_H

	econf \
		--disable-udunits \
		$(use_enable dap) \
		$(use_enable gsl) \
		$(use_enable hdf5 netcdf4) \
		$(use_enable ncap2) \
		$(use_enable openmp) \
		$(use_enable static-libs static) \
		$(use_enable udunits udunits2)
}

src_install() {
	default
	doinfo doc/*.info*

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
