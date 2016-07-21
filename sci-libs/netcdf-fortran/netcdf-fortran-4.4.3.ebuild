# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_STANDARD="77 90"

inherit autotools eutils fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-fortran/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND="sci-libs/netcdf"
DEPEND="${RDEPEND}
	dev-lang/cfortran
"

src_prepare() {
	# use system cfortran
	rm libsrc/cfortran.h || die

	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use examples && dodoc -r examples
	prune_libtool_files
}
