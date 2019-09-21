# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="CRC32C implementation with support for CPU-specific acceleration instructions"
HOMEPAGE="https://github.com/google/crc32c"
SRC_URI="https://github.com/google/crc32c/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DCRC32C_BUILD_TESTS=OFF
		-DCRC32C_BUILD_BENCHMARKS=OFF
		-DCRC32C_USE_GLOG=OFF
	)

	cmake-utils_src_configure
}
