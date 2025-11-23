# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
inherit cmake

DESCRIPTION="C library for arbitrary-precision interval arithmetic"
HOMEPAGE="https://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"
IUSE="test"

RESTRICT="!test? ( test )"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	>=sci-mathematics/flint-2.9.0:="

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
	)

	cmake_src_configure
}
