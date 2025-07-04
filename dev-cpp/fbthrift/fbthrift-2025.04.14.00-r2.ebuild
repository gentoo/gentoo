# Copyright 2022-2025 Gentoo Authors
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
KEYWORDS="amd64 ~arm64"
IUSE="io-uring test"

# See https://github.com/facebook/fbthrift/issues/628
RESTRICT="test"

DEPEND="
	~dev-cpp/fizz-${PV}:=
	~dev-cpp/folly-${PV}:=[io-uring(+)=]
	~dev-cpp/mvfst-${PV}:=
	~dev-cpp/wangle-${PV}:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-libs/boost:=[nls(+)]
	dev-libs/double-conversion:=
	dev-libs/libfmt:=
	dev-libs/openssl:=
	dev-libs/xxhash
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2025.04.14.00-Use-FOLLY_HAS_LIBURING-to-check-for-liburing-support.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DIR="$(get_libdir)/cmake/${PN}"
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Denable_tests=$(usex test 'ON' 'OFF')
		-Wno-dev
	)
	cmake_src_configure
}
