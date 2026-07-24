# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for reading AES SOFA (Spatially Oriented Format for Acoustics) files"
HOMEPAGE="https://github.com/hoene/libmysofa"
SRC_URI="https://github.com/hoene/libmysofa/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-util/cunit )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
