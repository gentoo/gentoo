# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/nco/nco-4.3.1.ebuild,v 1.1 2013/05/27 17:28:55 bicatali Exp $

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="Command line utilities for operating on netCDF files"
HOMEPAGE="http://nco.sourceforge.net/"
SRC_URI="http://nco.sf.net/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE="dap doc gsl ncap2 static-libs test udunits"

RDEPEND="
	>=sci-libs/netcdf-4[dap=]
	gsl? ( sci-libs/gsl )
	udunits? ( >=sci-libs/udunits-2 )"

DEPEND="${RDEPEND}
	ncap2? ( dev-java/antlr:0 )
	test? ( >=sci-libs/netcdf-4[tools] )"

src_configure() {
	local myconf
	if has_version '>=sci-libs/netcdf-4[hdf5]'; then
		myconf="--enable-netcdf4"
		append-cppflags -DHAVE_NETCDF4_H
	else
		myconf="--disable-netcdf4"
	fi
	econf \
		--disable-udunits \
		$(use_enable dap dap-netcdf) \
		$(use_enable gsl) \
		$(use_enable ncap2) \
		$(use_enable static-libs static) \
		$(use_enable udunits udunits2) \
		${myconf}
}

src_install() {
	default
	cd doc
	dodoc ANNOUNCE ChangeLog MANIFEST NEWS README TAG TODO VERSION *.txt
	doinfo *.info*
	use doc && dohtml nco.html && dodoc nco.pdf
}
