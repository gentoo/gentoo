# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Google Logging library"
HOMEPAGE="https://github.com/google/glog"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/google/glog"
	inherit git-r3
else
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="BSD"
SLOT="0/1"
IUSE="gflags +libunwind llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	gflags? ( dev-cpp/gflags:=[${MULTILIB_USEDEP}] )
	libunwind? (
		llvm-libunwind? ( llvm-runtimes/libunwind:=[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-cmake-4.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DWITH_GFLAGS=$(usex gflags ON OFF)
		-DWITH_GTEST=$(usex test ON OFF)
		-DWITH_UNWIND=$(usex libunwind ON OFF)
	)

	cmake-multilib_src_configure
}

src_test() {
	# Tests have a history of being brittle: bug #863599
	CMAKE_SKIP_TESTS=(
		logging
		stacktrace
		symbolize
		log_severity_conversion
		includes_vlog_is_on
		includes_raw_logging
	)

	cmake-multilib_src_test -j1
}
