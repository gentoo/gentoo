# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake edo flag-o-matic rocm

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/clr"

SRC_URI="https://github.com/ROCm-Developer-Tools/clr/archive/refs/tags/rocm-${PV}.tar.gz -> rocm-clr-${PV}.tar.gz"
S="${WORKDIR}/clr-rocm-${PV}/"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/rocr-runtime-6.0
	>=dev-libs/rocm-comgr-6.0
	>=dev-libs/rocm-device-libs-6.0
	>=virtual/opencl-3
	media-libs/mesa[-opencl]"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-build/rocm-cmake-5.3
	media-libs/glew
	test? ( >=x11-apps/mesa-progs-8.5.0[X] )
"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/856088
	# https://github.com/ROCm/clr/issues/64
	#
	# Do not trust it for LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	# Fix ld.lld linker error: https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/155
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	# Reported upstream: https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
	append-cflags -fcommon

	local mycmakeargs=(
		-Wno-dev
		-DROCM_PATH="${EPREFIX}/usr"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DEMU_ENV=ON
		-DBUILD_ICD=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCLR_BUILD_OCL=on
	)
	cmake_src_configure
}

src_install() {
	insinto /etc/OpenCL/vendors
	doins opencl/config/amdocl64.icd

	cd "${BUILD_DIR}"/opencl || die
	insinto /usr/lib64
	doins amdocl/libamdocl64.so
	doins tools/cltrace/libcltrace.so
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/tests/ocltst || die
	export OCL_ICD_FILENAMES="${BUILD_DIR}"/amdocl/libamdocl64.so
	local instruction1="Please start an X server using amdgpu driver (not Xvfb!),"
	local instruction2="and export OCLGL_DISPLAY=\${DISPLAY} OCLGL_XAUTHORITY=\${XAUTHORITY} before reruning the test."
	if [[ -n ${OCLGL_DISPLAY+x} ]]; then
		export DISPLAY=${OCLGL_DISPLAY}
		export XAUTHORITY=${OCLGL_XAUTHORITY}
		ebegin "Running oclgl test under DISPLAY ${OCLGL_DISPLAY}"
		if ! glxinfo | grep "OpenGL vendor string: AMD"; then
			ewarn "${instruction1}"
			ewarn "${instruction2}"
			die "This display does not have AMD OpenGL vendor!"
		fi
		./ocltst -m $(realpath liboclgl.so) -A ogl.exclude
		eend $? || die "oclgl test failed"
	else
		ewarn "${instruction1}"
		ewarn "${instruction2}"
		die "\${OCLGL_DISPLAY} not set."
	fi
	edob ./ocltst -m $(realpath liboclruntime.so) -A oclruntime.exclude
	edob ./ocltst -m $(realpath liboclperf.so) -A oclperf.exclude
}
