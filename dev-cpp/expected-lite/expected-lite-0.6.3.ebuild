# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Expected objects in C++11 and later in a single-file header-only library"
HOMEPAGE="https://github.com/martinmoene/expected-lite"

SRC_URI="https://github.com/martinmoene/expected-lite/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DEXPECTED_LITE_OPT_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
