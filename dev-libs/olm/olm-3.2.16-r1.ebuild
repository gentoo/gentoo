# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the Double Ratchet cryptographic ratchet in C++"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"
SRC_URI="https://gitlab.matrix.org/matrix-org/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=dev-build/cmake-3.31"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch" # TODO: upstream
	"${FILESDIR}/${P}-cmake4.patch" # bug 955895
	"${FILESDIR}/${P}-clang-19-const.patch"
)

src_prepare() {
	rm -rv lib/doctest || die # unused bundled stuff using <CMake-3.5
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
