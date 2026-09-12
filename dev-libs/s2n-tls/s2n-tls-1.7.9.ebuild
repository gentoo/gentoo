# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="s2n-tls is a C99 implementation of the TLS/SSL protocols"
HOMEPAGE="https://github.com/aws/s2n-tls"
SRC_URI="https://github.com/aws/s2n-tls/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	# stop overwriting LDFLAGS
	sed -i -e '/set(CMAKE_SHARED_LINKER_FLAGS/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)

	cmake_src_configure
}
