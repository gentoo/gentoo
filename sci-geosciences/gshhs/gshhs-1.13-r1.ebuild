# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Global Self-consistent, Hierarchical, High-resolution Shoreline programs"
HOMEPAGE="https://www.ngdc.noaa.gov/mgg/shorelines/gshhs.html"
SRC_URI="ftp://ftp.soest.hawaii.edu/pwessel/gshhs/gshhs_${PV}_src.zip"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+data"

RDEPEND="sci-libs/netcdf:=
	sci-libs/gdal:=
	data? ( sci-geosciences/gshhs-data )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	virtual/pkgconfig"

src_compile() {
	local p
	for p in gshhs gshhs_dp gshhstograss; do
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			$($(tc-getPKG_CONFIG) --cflags netcdf) \
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
