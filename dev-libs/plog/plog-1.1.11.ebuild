# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Portable, simple and extensible C++ logging library"
HOMEPAGE="https://github.com/SergiusTheBest/plog"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SergiusTheBest/plog.git"
else
	SRC_URI="https://github.com/SergiusTheBest/plog/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {
	local mycmakeargs=(
		-DPLOG_BUILD_SAMPLES=OFF
		-DPLOG_BUILD_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}
