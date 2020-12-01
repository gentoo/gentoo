# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake fortran-2

DESCRIPTION="BLAS,CBLAS,LAPACK,LAPACKE reference implementations"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="https://github.com/Reference-LAPACK/lapack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-3.9.0-build-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCBLAS=ON
		-DLAPACKE=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
