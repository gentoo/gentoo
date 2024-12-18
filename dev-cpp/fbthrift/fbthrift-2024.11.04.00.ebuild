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

DESCRIPTION="Facebook's branch of Apache Thrift (C++ bindings)"
HOMEPAGE="https://github.com/facebook/fbthrift"
SRC_URI="https://github.com/facebook/fbthrift/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

# See https://github.com/facebook/fbthrift/issues/628
RESTRICT="test"

DEPEND="
	app-arch/zstd:=
	~dev-cpp/fizz-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	~dev-cpp/mvfst-${PV}:=
	~dev-cpp/wangle-${PV}:=
	dev-libs/boost:=[nls(+)]
	dev-libs/libevent:=
	dev-libs/openssl:=
	dev-libs/xxhash:=
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DIR="$(get_libdir)/cmake/${PN}"
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Denable_tests=$(usex test 'ON' 'OFF')
		-Wno-dev
	)
	cmake_src_configure
}
