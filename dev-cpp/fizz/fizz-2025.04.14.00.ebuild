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

CMAKE_USE_DIR="${S}/fizz"

inherit cmake

DESCRIPTION="C++14 implementation of the TLS-1.3 standard"
HOMEPAGE="https://github.com/facebookincubator/fizz"
SRC_URI="https://github.com/facebookincubator/fizz/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

# NOTE: Fizz supports multiple backends but the CMake build only
#       allows building against OpenSSL. Can't do anything about
#       that unless Facebook supports other backends in CMake.
RDEPEND="
	app-arch/zstd:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-libs/double-conversion:=
	dev-libs/libfmt:=
	dev-libs/libsodium:=
	dev-libs/openssl:=
	sys-libs/zlib
"
uEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DIR="$(get_libdir)/cmake/${PN}"
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-DBUILD_TESTS="$(usex test ON OFF)"
	)

	cmake_src_configure
}
