# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

inherit cmake

# No proper tags yet (https://github.com/facebookexperimental/edencommon/issues/2)
MY_COMMIT="ca22cf964f1163c2a198d7cd3545f0c9b04b3c75"
DESCRIPTION="Shared library for Watchman and Eden projects"
HOMEPAGE="https://github.com/facebookexperimental/edencommon"
SRC_URI="https://github.com/facebookexperimental/edencommon/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
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
