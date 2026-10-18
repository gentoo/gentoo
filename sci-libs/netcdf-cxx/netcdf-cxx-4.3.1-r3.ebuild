# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

MYP=${PN}4-${PV}
DESCRIPTION="C++ library for netCDF"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://downloads.unidata.ucar.edu/netcdf-cxx/${PV}/${PN}4-${PV}.tar.gz"

S="${WORKDIR}/${MYP}"

LICENSE="UCAR-Unidata"
SLOT="0/1"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="examples"

RDEPEND=">=sci-libs/netcdf-4.2:=[hdf5,logging]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-slibtool.patch
)

src_prepare() {
	default
	elibtoolize
}

src_install() {
	default

	if use examples; then
		rm -r examples/.libs || die

		# Remove architecture-dependent object files
		find examples -type f -name "*.o" -delete

		use examples && dodoc -r examples
	fi
	find "${ED}" -name '*.la' -delete || die
}

src_test() {
	MAKEOPTS=-j1 default
}
