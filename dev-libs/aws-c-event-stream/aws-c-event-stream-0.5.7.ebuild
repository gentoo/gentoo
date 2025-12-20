# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Core c99 package for AWS SDK for C."
HOMEPAGE="https://github.com/awslabs/aws-c-event-stream"
SRC_URI="https://github.com/awslabs/aws-c-event-stream/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="dev-libs/aws-c-common
dev-libs/aws-c-io
dev-libs/aws-checksums"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	use test && mycmakeargs+=(
		-DENABLE_NET_TESTS=OFF # Network Sandbox cause these to fail.
	)

	cmake_src_configure
}
