# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Single header implementation of std::expected with functional-style extensions"
HOMEPAGE="https://github.com/TartanLlama/expected"

SRC_URI="https://github.com/TartanLlama/expected/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DEXPECTED_BUILD_TESTS=OFF
	)

	cmake_src_configure
}
