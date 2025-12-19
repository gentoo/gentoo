# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD="77 90"

inherit flag-o-matic fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
# TODO: drop .upstream suffix on next bump
SRC_URI="https://downloads.unidata.ucar.edu/netcdf-fortran/${PV}/${P}.tar.gz -> ${P}.upstream.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/7"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND="sci-libs/netcdf"
DEPEND="
	${RDEPEND}
	dev-lang/cfortran
"
BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927588
	# https://github.com/Unidata/netcdf-fortran/issues/437
	filter-lto

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
