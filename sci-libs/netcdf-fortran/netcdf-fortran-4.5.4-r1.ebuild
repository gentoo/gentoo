# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD="77 90"

inherit fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
# TODO: drop .upstream suffix on next bump
SRC_URI="https://downloads.unidata.ucar.edu/netcdf-fortran/${PV}/${P}.tar.gz -> ${P}.upstream.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/7"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="sci-libs/netcdf"
DEPEND="
	${RDEPEND}
	dev-lang/cfortran
"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--disable-valgrind \
		--with-temp-large="${T}" \
		--disable-dot \
		$(use_enable doc doxygen) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use examples && dodoc -r examples
	find "${ED}" -name '*.la' -delete || die
}
