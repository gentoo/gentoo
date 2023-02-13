# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The fastest feature-rich C++11/14/17/20 single-header testing framework"
HOMEPAGE="https://github.com/doctest/doctest"
SRC_URI="https://github.com/doctest/doctest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DDOCTEST_WITH_TESTS=$(usex test)
	)
	cmake_src_configure
}
