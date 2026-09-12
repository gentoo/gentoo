# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C Auth: C99 library implementation of AWS client-side authentication"
HOMEPAGE="https://github.com/awslabs/aws-c-auth"
SRC_URI="https://github.com/awslabs/aws-c-auth/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/aws-c-cal-1.0.0:=
	>=dev-libs/aws-c-common-1.0.0:=
	>=dev-libs/aws-c-http-1.0.0:=
	>=dev-libs/aws-c-sdkutils-1.0.0:=
"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure() {
	local mycmakeargs=(
		-DAWS_GET_VERSION_MODULE="${ESYSROOT}/usr/$(get_libdir)/cmake/aws-c-common/modules/AwsGetVersion.cmake"
		-DBUILD_TESTING=$(usex test)
	)
	use test && mycmakeargs+=(
		-DENABLE_NET_TESTS=OFF # Network Sandbox cause these to fail.
	)
	cmake_src_configure
}
