# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://nco.sf.net/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="dap gsl hdf5 ncap2 openmp test udunits"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-libs/netcdf-4:=[dap=,hdf5?,tools(+)]
	gsl? ( sci-libs/gsl:= )
	ncap2? ( dev-cpp/antlr-cpp:2= )
	udunits? ( >=sci-libs/udunits-2 )"
DEPEND="${RDEPEND}
	test? ( >=sci-libs/netcdf-4[tools(+)] )"
BDEPEND="sys-apps/texinfo"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	econf \
		--disable-udunits \
		--disable-gpu \
		--enable-doc \
		$(use_enable dap) \
		$(use_enable gsl) \
		$(use_enable hdf5 netcdf4) \
		$(use_enable hdf5 netcdf-4) \
		$(use_enable ncap2) \
		$(use_enable ncap2 ncoxx) \
		$(use_enable openmp) \
		$(use_enable udunits udunits2)
}

src_test() {
	emake test
	# testsuite doesn't run through automake
	rm src/nco/test-suite.log || die
}

src_install() {
	default
	dodoc doc/ChangeLog

	find "${ED}" -name '*.la' -delete || die
}
