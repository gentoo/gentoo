# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ wrapper around the aws-c-* libraries"
HOMEPAGE="https://github.com/awslabs/aws-crt-cpp"
SRC_URI="https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/aws-c-auth:=
	dev-libs/aws-c-cal:=
	dev-libs/aws-c-common:=
	dev-libs/aws-c-event-stream:=
	dev-libs/aws-c-http:=
	dev-libs/aws-c-io:=
	dev-libs/aws-c-mqtt:=
	dev-libs/aws-c-s3:=
	dev-libs/aws-checksums:=
	"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure()
{
	local mycmakeargs=(
		-DBUILD_DEPS=OFF # disable embedded 3rd-party repositories.
		-DBUILD_TESTING=$(usex test)
	)

	use test && mycmakeargs+=(
		-DENABLE_NET_TESTS=OFF # Network Sandbox cause these to fail.
	)

	cmake_src_configure
}
