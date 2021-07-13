# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_STANDARD=77

inherit cmake fortran-2

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="https://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="https://crd-legacy.lbl.gov/~xiaoye/SuperLU//${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig
	test? ( app-shells/tcsh )"
RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-5.2.2-no-internal-blas.patch"
)

src_prepare() {
	cmake_src_prepare
	# respect user's CFLAGS
	sed -i -e 's/O3//' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs+=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/superlu"
		-DBUILD_SHARED_LIBS=ON
		-Denable_internal_blaslib=OFF
		-Denable_tests=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc -r DOC/html
	if use examples; then
		docinto examples
		dodoc -r EXAMPLE FORTRAN
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
