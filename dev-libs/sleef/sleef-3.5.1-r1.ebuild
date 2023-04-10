# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implements vectorized versions of C standard math functions"
HOMEPAGE="https://sleef.org/"
SRC_URI="https://github.com/shibatch/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-riscv.patch
)

src_configure() {
	local mycmakeargs=(
		-DDISABLE_FFTW=ON
		-DBUILD_QUAD=ON
		-DBUILD_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}
