# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ library for netCDF"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://www.unidata.ucar.edu/downloads/netcdf/ftp/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="3"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND=">=sci-libs/netcdf-4.2:0="
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	if use examples ; then
		docinto examples
		dodoc -r examples
	fi
}
