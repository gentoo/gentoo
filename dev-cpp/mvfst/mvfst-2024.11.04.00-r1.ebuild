# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/fb303
# dev-cpp/fbthrift
# dev-cpp/fizz
# dev-cpp/folly
# dev-cpp/mvfst
# dev-cpp/wangle
# dev-util/watchman

inherit cmake

DESCRIPTION="An implementation of the QUIC transport protocol"
HOMEPAGE="https://github.com/facebook/mvfst"
SRC_URI="https://github.com/facebook/mvfst/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	~dev-cpp/fizz-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-libs/boost:=
	dev-libs/libfmt:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_MODULE_DIR="$(get_libdir)/cmake/${PN}"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DBUILD_TESTS="$(usex test ON OFF)"
	)

	cmake_src_configure
}

src_test() {
	if use arm64; then
		# These tests segfault on arm64.
		# https://github.com/facebook/mvfst/issues/363
		CMAKE_SKIP_TESTS=(
			QuicClientTransportIntegrationTest.ResetClient
			QuicClientTransportIntegrationTest.TestStatelessResetToken
		)
	fi

	cmake_src_test
}
