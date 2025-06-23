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

DESCRIPTION="Core set of Thrift functions querying stats and other information from a service"
HOMEPAGE="https://github.com/facebook/fb303"
SRC_URI="https://github.com/facebook/fb303/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64"
IUSE="test"

# See https://github.com/facebook/fb303/issues/61
RESTRICT="test"

RDEPEND="
	~dev-cpp/fbthrift-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-libs/libfmt:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2025.04.14.00-Fix-using-the-Thrift-annotation-library-for-the-Pyth.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DIR="$(get_libdir)/cmake/${PN}"
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	cmake_src_configure
}
