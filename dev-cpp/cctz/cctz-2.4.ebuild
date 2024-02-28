# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library for dealing with time zones and time conversion"
HOMEPAGE="https://github.com/google/cctz"
SRC_URI="https://github.com/google/cctz/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-cpp/gtest
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DBUILD_BENCHMARK=OFF
	)
	cmake_src_configure
}
