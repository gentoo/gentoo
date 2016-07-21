# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils flag-o-matic

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://nco.sf.net/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="dap doc gsl ncap2 openmp static-libs test udunits"

RDEPEND="
	>=sci-libs/netcdf-4:=[dap=,tools]
	gsl? ( sci-libs/gsl:= )
	ncap2? ( dev-cpp/antlr-cpp:2= )
	udunits? ( >=sci-libs/udunits-2 )"

DEPEND="${RDEPEND}
	test? ( >=sci-libs/netcdf-4[tools] )"

src_configure() {
	local myeconfargs=(
		--disable-udunits
		$(use_enable dap dap-netcdf)
		$(use_enable gsl)
		$(use_enable ncap2)
		$(use_enable openmp)
		$(use_enable udunits udunits2)
	)
	if has_version '>=sci-libs/netcdf-4[hdf5]'; then
		myeconfargs+=( --enable-netcdf4 )
		append-cppflags -DHAVE_NETCDF4_H
	else
		myeconfargs+=( --disable-netcdf4 )
	fi
	autotools-utils_src_configure
}

src_install() {
	use doc && DOCS=( doc/nco.pdf ) && HTML_DOCS=( doc/nco.html )
	autotools-utils_src_install
	doinfo doc/*.info*
}
