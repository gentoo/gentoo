# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
inherit cmake flag-o-matic rocm

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocprim"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocprim.tar.gz -> rocprim-${PV}.tar.gz
	benchmark? (
		https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/primbench.tar.gz
			-> primbench-${PV}.tar.gz
	)
"
S="${WORKDIR}/rocprim"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="
	benchmark? ( ${ROCM_REQUIRED_USE} )
	test? ( ${ROCM_REQUIRED_USE} )
"

RDEPEND="
	benchmark? (
		dev-util/amdsmi:${SLOT}
		dev-util/hip:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
	dev-util/hip:${SLOT}
	test? ( dev-cpp/gtest )
"
BDEPEND="dev-build/rocm-cmake"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-10.1.0-int128-hash.patch
)

src_prepare() {
	# prefix installed benchmark names; primbench comes from its own tarball
	if use benchmark; then
		sed -e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
			-e "s:\.\./\.\./\.\./shared/primbench:${WORKDIR}/primbench:" \
			-i benchmark/CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# too many warnings in tests
	append-cxxflags -Wno-explicit-specialization-storage-class -Wno-deprecated-declarations
	# tests check error returns that are guarded by asserts (disabled in upstream release builds)
	append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	# Inputs of 2^30..2^37 elements: either many GiB of memory, or kernels running for many
	# seconds. On APUs both starve the display (gfx ring timeout, crashing the desktop session).
	local -x GTEST_FILTER="-*LargeIndices*:*LargeInput*:*LargeSizes*:*LargeSegmentCount*"
	GTEST_FILTER+=":RocprimDeviceReduceByKey.GraphReduceByKey:RocprimDeviceRadixSort.SortKeysOver4G*"
	GTEST_FILTER+=":DeviceMergeInplaceTests/11.*:DeviceMergeInplaceTests/12.*"
	# 1-2 KiB element types: several GiB per test
	GTEST_FILTER+=":RocprimDeviceSortTests/20.SortKeyValue:RocprimDeviceSortTests/21.*"
	GTEST_FILTER+=":RocprimDevicePartitionTests/11.*:RocprimDeviceSelectTests/CustomHugeType1024Int.*"
	GTEST_FILTER+=":RocprimDeviceUniqueByKeyTests/9.*"
	# test_linking needs the test libraries next to it (CMAKE_SKIP_RPATH)
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/test/rocprim"
	cmake_src_test -j1
}
