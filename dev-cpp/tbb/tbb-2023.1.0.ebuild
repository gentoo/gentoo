# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://github.com/uxlfoundation/oneTBB"
SRC_URI="https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oneTBB-${PV}"

LICENSE="Apache-2.0"
# See VERSIONING.md
# __TBB_BINARY_VERSION in include/oneapi/tbb/version.h -> libtbb.so.<SONAME>
# TBBMALLOC_BINARY_VERSION in CMakeLists.txt -> libtbbmalloc.so.<SONAME>
# TBBBIND_BINARY_VERSION in CMakeListst.txt -> libtbbbind.so.<SONAME>
SLOT="0/12.2.3" # TBB_BINARY_VERSION.TBBMALLOC_VERSION.TBBBIND_VERSION
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="!kernel_Darwin? ( sys-apps/hwloc:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2021.9.0-ppc.patch
	"${FILESDIR}"/${PN}-2021.13.0-test-atomics.patch
	"${FILESDIR}"/${PN}-2023.1.0-no-clobber-toolchain.patch
)

src_prepare() {
	# sanity check subslot
	local detected_abi tbb_version tbbmalloc_version tbbbind_version
	tbb_version="$(sed -n -e 's/^#define __TBB_BINARY_VERSION \(.*\)$/\1/p' include/oneapi/tbb/version.h)"
	tbbmalloc_version="$(sed -n -e 's/^set(TBBMALLOC_BINARY_VERSION \(.*\))$/\1/p' CMakeLists.txt)"
	tbbbind_version="$(sed -n -e 's/^set(TBBBIND_BINARY_VERSION \(.*\))$/\1/p' CMakeLists.txt)"
	detected_abi="${tbb_version}.${tbbmalloc_version}.${tbbbind_version}"
	if [[ "${SLOT}" != "0/${detected_abi}" ]]; then
		die "SLOT ${SLOT} doesn't match upstream specified ABI ${detected_abi}."
	fi

	# Silence cmake warnings
	rm -r examples || die

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #912210
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local mycmakeargs=(
		-DTBB_TEST=$(usex test)
		-DTBB_EXAMPLES=OFF # TODO: add this

		-DTBB_ENABLE_IPO=OFF # Use user cflags instead
		-DTBB_STRICT=OFF # Don't turn warnings into errors
	)

	cmake-multilib_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()
	if use elibc_musl; then
		CMAKE_SKIP_TESTS+=( conformance_resumable_tasks ) # Bug #864175
	fi
	cmake-multilib_src_test
}
