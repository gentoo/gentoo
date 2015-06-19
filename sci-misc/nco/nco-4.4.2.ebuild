# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/nco/nco-4.4.2.ebuild,v 1.3 2014/08/07 16:45:53 mgorny Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils flag-o-matic

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://nco.sf.net/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE="dap doc gsl ncap2 static-libs test udunits"

RDEPEND="
	>=sci-libs/netcdf-4:=[dap=]
	gsl? ( sci-libs/gsl:= )
	udunits? ( >=sci-libs/udunits-2 )"

DEPEND="${RDEPEND}
	ncap2? ( dev-java/antlr:0 )
	test? ( >=sci-libs/netcdf-4[tools] )"

src_configure() {
	local myeconfargs=(
		--disable-udunits
		$(use_enable dap dap-netcdf)
		$(use_enable gsl)
		$(use_enable ncap2)
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
	autotools-utils_src_install
	cd doc
	doinfo *.info*
	use doc && dohtml nco.html && dodoc nco.pdf
}
