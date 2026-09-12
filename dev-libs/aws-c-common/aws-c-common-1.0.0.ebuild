# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Core c99 package for AWS SDK for C"
HOMEPAGE="https://github.com/awslabs/aws-c-common"
SRC_URI="https://github.com/awslabs/aws-c-common/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

CMAKE_SKIP_TESTS=(
	# https://github.com/awslabs/aws-c-common/issues/1274
	test_file_path_read_from_offset_direct_io
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
