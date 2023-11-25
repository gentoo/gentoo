# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

inherit cmake

DESCRIPTION="Shared library for Watchman and Eden projects"
HOMEPAGE="https://github.com/facebookexperimental/edencommon"
SRC_URI="https://github.com/facebookexperimental/edencommon/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE="llvm-libunwind"

RDEPEND="
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-cpp/folly:=
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
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
