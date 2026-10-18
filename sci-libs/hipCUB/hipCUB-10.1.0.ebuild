# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Wrapper of rocPRIM or CUB for GPU parallel primitives"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipcub"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/hipcub.tar.gz -> hipcub-${PV}.tar.gz
	benchmark? (
		https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/primbench.tar.gz
			-> primbench-${PV}.tar.gz
	)
"
S="${WORKDIR}/hipcub"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test"
REQUIRED_USE="
	benchmark? ( ${ROCM_REQUIRED_USE} )
	test? ( ${ROCM_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	benchmark? ( dev-util/hip:${SLOT} )
"
DEPEND="
	${RDEPEND}
	dev-util/hip:${SLOT}
	sci-libs/rocPRIM:${SLOT}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-10.1.0-no-tests-install.patch
	"${FILESDIR}"/${PN}-10.1.0-libcxx.patch
)

src_prepare() {
	# primbench comes from its own tarball
	if use benchmark; then
		sed -e "s:\.\./\.\./\.\./shared/primbench:${WORKDIR}/primbench:" \
			-i benchmark/CMakeLists.txt || die
	fi

	# the test writes to (and compares) vectors that are only reserve()d
	sed -e "s/\(expected\|h_output\)\.reserve(extents_size)/\1.resize(extents_size)/" \
		-i test/hipcub/test_hipcub_device_for.cpp || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	# Expected time on gfx1100 (-j32) is 85s
	# Inputs of 2^30..2^34 elements: either many GiB of memory, or kernels running for many
	# seconds. On APUs both starve the display (gfx ring timeout, crashing the desktop session).
	local -x GTEST_FILTER="-*LargeIndices*:*LargeSize*:HipcubDeviceRadixSort.SortKeysOver4G"
	cmake_src_test
}
