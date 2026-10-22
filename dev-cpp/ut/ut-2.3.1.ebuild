# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="C++20 μ(micro)/Unit Testing framework"
HOMEPAGE="https://github.com/boost-ext/ut"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/boost-ext/ut"
else
	SRC_URI="
		https://github.com/boost-ext/ut/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBOOST_UT_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
