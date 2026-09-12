# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C IO: It handles all IO and TLS work for application protocols"
HOMEPAGE="https://github.com/awslabs/aws-c-io"
SRC_URI="https://github.com/awslabs/aws-c-io/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/aws-c-cal-1.0.0:=
	>=dev-libs/aws-c-common-1.0.0:=
	dev-libs/s2n-tls
"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure() {
	local mycmakeargs=(
		-DAWS_GET_VERSION_MODULE="${ESYSROOT}/usr/$(get_libdir)/cmake/aws-c-common/modules/AwsGetVersion.cmake"
		-DBUILD_TESTING=$(usex test)
	)

	if use test; then
		# (#759802) Due to network sandboxing of portage, internet connectivity
		# tests will always fail. If you need a USE flag, because you want/need
		# to perform these tests manually, please open a bug report for it.
		mycmakeargs+=(
			-DENABLE_NET_TESTS=OFF
		)
	fi

	cmake_src_configure
}
