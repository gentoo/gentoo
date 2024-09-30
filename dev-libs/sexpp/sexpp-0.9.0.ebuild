# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="S-expressions parser and generator library in C++"
HOMEPAGE="https://github.com/rnpgp/sexpp"
SRC_URI="https://github.com/rnpgp/sexpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE="cli test"

BDEPEND="virtual/pkgconfig
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=on

		-DDOWNLOAD_GTEST=off

		-DWITH_ABI_TEST=off
		-DWITH_COVERAGE=off
		-DWITH_SANITIZERS=off
		-DWITH_SEXP_CLI=$(usex cli on off)
		-DWITH_SEXP_TESTS=$(usex test on off)
	)

	cmake_src_configure
}
