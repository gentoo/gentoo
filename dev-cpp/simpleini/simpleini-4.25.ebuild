# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library providing a simple API to read and write INI-style files"
HOMEPAGE="https://github.com/brofield/simpleini/"
SRC_URI="https://github.com/brofield/simpleini/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DSIMPLEINI_USE_SYSTEM_GTEST=yes
	)

	cmake_src_configure
}
