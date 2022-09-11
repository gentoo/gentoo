# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/folly/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE="llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="app-arch/bzip2
	app-arch/lz4:=
	app-arch/snappy:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags]
	dev-libs/boost:=[context]
	dev-libs/double-conversion:=
	dev-libs/libaio
	dev-libs/libevent:=
	dev-libs/libfmt:=
	dev-libs/libsodium:=
	dev-libs/openssl:=
	sys-libs/liburing:=
	sys-libs/zlib
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )"
# libiberty is linked statically
DEPEND="${RDEPEND}
	sys-libs/binutils-libs"
BDEPEND="test? ( sys-devel/clang )"

pkg_setup() {
	if use test && [[ ${BUILD_TYPE} != "binary" ]] && ! tc-is-clang ; then
		ewarn "Forcing build with Clang due to GCC bug (because tests are enabled)"
		ewarn "(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104008)"

		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
	fi
}

src_configure() {
	# TODO: liburing could in theory be optional but fails to link

	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"

		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
