# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Prometheus Client Library for Modern C++"
HOMEPAGE="https://github.com/jupp0r/prometheus-cpp"
SRC_URI="https://github.com/jupp0r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/cppcodec
	net-misc/curl
	sys-libs/zlib
	www-servers/civetweb[cxx]"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/benchmark
		dev-cpp/gtest
	)"

PATCHES=(
	"${FILESDIR}/${P}-core-Skip-serialization-test-if-locale-is-not-availa.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_PULL=yes
		-DENABLE_PUSH=yes
		-DENABLE_COMPRESSION=$(usex zlib)
		-DENABLE_TESTING=$(usex test)
		-DUSE_THIRDPARTY_LIBRARIES=OFF
	)

	cmake_src_configure
}
