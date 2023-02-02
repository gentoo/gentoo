# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

inherit cmake toolchain-funcs

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/folly/releases/download/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64"
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
	>=sys-libs/liburing-2.3:=
	sys-libs/zlib
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )"
# libiberty is linked statically
DEPEND="${RDEPEND}
	sys-libs/binutils-libs
	test? ( dev-cpp/gtest )"
BDEPEND="test? ( sys-devel/clang )"

PATCHES=(
	"${FILESDIR}"/${PN}-2022.07.04.00-musl-fix.patch
)

pkg_setup() {
	[[ ${BUILD_TYPE} == binary ]] && return

	if use test && ! tc-is-clang ; then
		# Always build w/ Clang for now to avoid gcc ICE
		# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106230
		#if [[ $(gcc-major-version) -eq 12 ]] ; then
		#	return
		#fi

		## Only older GCC 11 is broken
		#if [[ $(gcc-major-version) -eq 11 && $(gcc-minor-version) -ge 3 && $(gcc-micro-version) -ge 1 ]] ; then
		#	return
		#fi

		ewarn "Forcing build with Clang due to GCC bug (because tests are enabled)"
		#ewarn "(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104008)"

		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
	fi
}

src_configure() {
	# Fragile when changing compilers
	export CCACHE_DISABLE=1

	# TODO: liburing could in theory be optional but fails to link
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"

		-DBUILD_TESTS=$(usex test)

		# https://github.com/gentoo/gentoo/pull/29393
		-DCMAKE_LIBRARY_ARCHITECTURE=$(usex amd64 x86_64 ${ARCH})
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# - timeseries_histogram_test.TimeseriesHistogram.Percentile|HHWheelTimerTest
		# Long-standing known test failure
		# TODO: report upstream
		# - HHWheelTimerTest.HHWheelTimerTest.CancelTimeout
		# Timeouts are fragile
		# - concurrent_hash_map_test.*
		# TODO: All SIGSEGV, report upstream!
		-E "(timeseries_histogram_test.TimeseriesHistogram.Percentile|HHWheelTimerTest.HHWheelTimerTest.CancelTimeout|concurrent_hash_map_test.*)"
	)

	cmake_src_test
}
