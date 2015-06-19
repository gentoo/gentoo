# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/netcdf-cxx/netcdf-cxx-4.2-r300.ebuild,v 1.3 2015/02/22 10:58:15 pacho Exp $

EAPI=5

inherit autotools-utils versionator

DESCRIPTION="C++ library for netCDF"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://www.unidata.ucar.edu/downloads/netcdf/ftp/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="3"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND=">=sci-libs/netcdf-4.2"
DEPEND="${RDEPEND}"

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
