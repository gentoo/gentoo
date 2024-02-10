# Copyright 2011-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake-multilib

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/google/glog"
fi

DESCRIPTION="Google Logging library"
HOMEPAGE="https://github.com/google/glog"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="gflags +libunwind llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="gflags? ( dev-cpp/gflags:0=[${MULTILIB_USEDEP}] )
	libunwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind:0=[${MULTILIB_USEDEP}] )
		!llvm-libunwind? ( sys-libs/libunwind:0=[${MULTILIB_USEDEP}] )
	)"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${P}-IsGoogleLoggingInitialized_public.patch"
	"${FILESDIR}/${P}-vmodule_levels_changeability.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DWITH_CUSTOM_PREFIX=ON
		-DWITH_GFLAGS=$(usex gflags ON OFF)
		-DWITH_GTEST=$(usex test ON OFF)
		-DWITH_UNWIND=$(usex libunwind ON OFF)
	)
	if use libunwind; then
		mycmakeargs+=(
			-DUnwind_PLATFORM_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/libunwind.so"
		)
	fi

	cmake-multilib_src_configure
}

src_test() {
	# See bug #832355
	cmake-multilib_src_test -j1
}
