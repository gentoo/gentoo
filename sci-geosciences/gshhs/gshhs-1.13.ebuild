# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gshhs/gshhs-1.13.ebuild,v 1.3 2013/11/20 19:50:49 bicatali Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Global Self-consistent, Hierarchical, High-resolution Shoreline programs"
HOMEPAGE="http://www.ngdc.noaa.gov/mgg/shorelines/gshhs.html"
SRC_URI="ftp://ftp.soest.hawaii.edu/pwessel/gshhs/gshhs_1.13_src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+data"

RDEPEND="sci-libs/netcdf
	sci-libs/gdal
	data? ( sci-geosciences/gshhs-data )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() {
	local p
	for p in gshhs gshhs_dp gshhstograss; do
		$(tc-getCC) ${CFLAGS} $($(tc-getPKG_CONFIG) --cflags netcdf) \
			${LDFLAGS} ${p}.c \
			$($(tc-getPKG_CONFIG) --libs netcdf) -lgdal -lm -o ${p} \
			|| die
	done
}

src_install() {
	dobin gshhs gshhs_dp gshhstograss
	insinto /usr/include
	doins gshhs.h
	dodoc README.gshhs
}
