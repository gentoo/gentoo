# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ implementation of the SciTokens library with a C library interface"
HOMEPAGE="https://github.com/scitokens/scitokens-cpp"
SRC_URI="https://github.com/scitokens/scitokens-cpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="test" # testing requires network

DEPEND="
		dev-db/sqlite
		dev-libs/openssl:0=
		net-misc/curl:0=
		kernel_linux? ( sys-apps/util-linux )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		-DSCITOKENS_BUILD_UNITTESTS=$(usex test)
		-DSCITOKENS_EXTERNAL_GTEST=1
	)
	cmake_src_configure
}
