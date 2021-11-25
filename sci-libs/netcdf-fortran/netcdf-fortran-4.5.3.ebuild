# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_STANDARD="77 90"

inherit autotools fortran-2 flag-o-matic

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-fortran/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/7"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND="sci-libs/netcdf"
DEPEND="${RDEPEND}
	dev-lang/cfortran"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# GCC 10 workaround
	# bug #723274
	# (As of 4.5.3, configure is meant to check for this flag & use it
	# but it doesn't seem to be doing that.)
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

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
