# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ELF reader/producer header-only C++ library"
HOMEPAGE="https://github.com/serge1/ELFIO"
SRC_URI="https://github.com/serge1/${PN}/archive/Release_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN^^}-Release_${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.11-system-gtest.patch
)

src_configure() {
	local mycmakeargs=(
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DELFIO_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
