# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library for dealing with time zones and time conversion"
HOMEPAGE="https://github.com/google/cctz"
MY_COMMIT="3803b96130934f48b1fc1d47c5da5f542949c4b0"
SRC_URI="https://github.com/google/cctz/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
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
