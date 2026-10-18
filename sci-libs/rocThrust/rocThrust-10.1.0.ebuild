# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake flag-o-matic rocm toolchain-funcs

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocthrust"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocthrust.tar.gz -> rocthrust-${PV}.tar.gz
	benchmark? (
		https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/primbench.tar.gz
			-> primbench-${PV}.tar.gz
	)
"
S="${WORKDIR}/rocthrust"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="
	benchmark? ( ${ROCM_REQUIRED_USE} )
	test? ( ${ROCM_REQUIRED_USE} )
"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocPRIM:${SLOT}
	test? (
		dev-cpp/gtest
		>=dev-db/sqlite-3.51.3:3
	)
	benchmark? ( sci-libs/rocRAND:${SLOT} )
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-build/cmake-3.22"

PATCHES=(
	"${FILESDIR}/${PN}-6.4.1-fix-libcxx.patch"
	"${FILESDIR}/${PN}-10.1.0-no-tests-install.patch"
	"${FILESDIR}/${PN}-10.1.0-libcxx.patch"
)

src_prepare() {
	# primbench comes from its own tarball
	if use benchmark; then
		sed -e "s:\${PROJECT_SOURCE_DIR}/\.\./\.\./shared/primbench:${WORKDIR}/primbench:" \
			-i benchmark/CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang
	# tests trip an assert in thrust/mr/pool.h (disabled in upstream release builds)
	append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		# not packaged
		-DCMAKE_DISABLE_FIND_PACKAGE_libhipcxx=ON
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	# Inputs of 2^30..2^33 elements: kernels running for seconds starve the display
	# on APUs (gfx ring timeout, crashing the desktop session)
	local -x GTEST_FILTER="-*WithBigIndexes*:*TestUniqueCopyByKeyLarge*"
	# reduces over the gap between two unrelated device allocations
	GTEST_FILTER+=":AsyncReduceTests.test_async_reduce_bug1886"
	# the libc++ reference, log(z + sqrt(z * z - 1)), overflows or loses precision
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		GTEST_FILTER+=":VariousComplexTest/*.acos:VariousComplexTest/*.acosh"
	fi
	# upstream thrust tests with big-index cases, which cannot be excluded individually
	local CMAKE_SKIP_TESTS=(
		"^(gfx[0-9a-z]+-)?(binary_search|copy|count|equal|find|for_each|inner_product)$"
		"^(gfx[0-9a-z]+-)?(max_element|min_element|minmax_element|partition_point)$"
		"^(gfx[0-9a-z]+-)?(reduce|scan|set_difference|set_intersection)$"
	)
	cmake_src_test -j1
}
