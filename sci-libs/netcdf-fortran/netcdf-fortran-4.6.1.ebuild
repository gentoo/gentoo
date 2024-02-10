# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD="77 90"

inherit cmake fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://downloads.unidata.ucar.edu/netcdf-fortran/${PV}/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/7"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test zstd"
RESTRICT="!test? ( test )"

RDEPEND="sci-libs/netcdf"
DEPEND="
	${RDEPEND}
	dev-lang/cfortran
"
BDEPEND="doc? ( app-text/doxygen[dot] )"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ZSTANDARD_PLUGIN=$(usex !zstd)
		-DBUILD_EXAMPLES=$(usex examples)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_PARALLEL_TESTS=$(usex test)
		-DENABLE_TESTS=$(usex test)

		# "Take lots of time and disk." per CMakeLists.txt
		#-DLARGE_FILE_TESTS="${T}"

		-DTEST_WITH_VALGRIND=OFF
	)

	cmake_src_configure
}
