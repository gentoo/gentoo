# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=d6860c477c99f1fce9e28eb206891af3c0e1a1d7

DESCRIPTION="C-style (a-la printf) logging library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
SRC_URI="https://github.com/pytorch/cpuinfo/archive/${CommitId}.tar.gz
	-> cpuinfo-${PV}.tar.gz"

S="${WORKDIR}"/clog

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="!<dev-libs/cpuinfo-${PV}"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_unpack() {
	unpack "${A}"
	mv cpuinfo-${CommitId}/deps/clog clog || die
	rm -r cpuinfo-${CommitId} || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_LIBS=ON
		-DUSE_SYSTEM_GOOGLETEST=ON
		-DCLOG_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
