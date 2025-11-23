# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool

MYP=${PN}4-${PV}
DESCRIPTION="C++ library for netCDF"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-cxx4/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/1"
KEYWORDS="amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
# 6 out of 9 fail, reported upstream
RESTRICT="test"

RDEPEND=">=sci-libs/netcdf-4.2:=[hdf5]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}"/${P}-slibtool.patch
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	use examples && dodoc -r examples
	find "${ED}" -name '*.la' -delete || die
}
