# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast Jaro and Jaro Winkler distance"
HOMEPAGE="https://github.com/maxbachmann/jarowinkler-cpp/"
SRC_URI="
	https://github.com/maxbachmann/jarowinkler-cpp/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		>=dev-cpp/catch-3
	)
"

src_configure() {
	local mycmakeargs=(
		-DJARO_WINKLER_BUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
