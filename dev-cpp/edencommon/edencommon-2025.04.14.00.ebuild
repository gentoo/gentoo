# Copyright 2022-2026 Gentoo Authors
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

inherit cmake toolchain-funcs

DESCRIPTION="Shared library for Watchman and Eden projects"
HOMEPAGE="https://github.com/facebookexperimental/edencommon"
SRC_URI="https://github.com/facebookexperimental/edencommon/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64"
IUSE="llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/glog:=
	~dev-cpp/folly-${PV}:=
	~dev-cpp/fb303-${PV}:=
	dev-libs/boost:=
	dev-libs/libfmt:=
	llvm-libunwind? ( llvm-runtimes/libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
"
DEPEND="
	${RDEPEND}
	dev-cpp/gtest
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DIR="$(get_libdir)/cmake/${PN}"
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# Tests fail because they try to obtain the real UID/username,
		# which is different from the test runner (portage).
		# https://github.com/facebookexperimental/edencommon/issues/25
		"ProcessInfoTest.readUserInfoForCurrentProcess"
		"ProcessInfoTest.testUidToUsername"
	)

	# This test fails on GCC 13.
	# https://github.com/facebookexperimental/edencommon/issues/22
	if tc-is-gcc && ver_test $(gcc-version) -lt 14.0.0; then
		CMAKE_SKIP_TESTS+=(PathFuncs.move_or_copy)
	fi

	cmake_src_test
}
