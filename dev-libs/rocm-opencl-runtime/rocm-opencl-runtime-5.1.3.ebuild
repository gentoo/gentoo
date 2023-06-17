# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo flag-o-matic prefix

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> rocclr-${PV}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RESTRICT="!test? ( test )"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=dev-libs/rocm-comgr-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	>=virtual/opencl-3
	media-libs/mesa"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/rocm-cmake-${PV}
	media-libs/glew
	test? ( >=x11-apps/mesa-progs-8.5.0[X] )
	"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-remove-clinfo.patch"
	"${FILESDIR}/${PN}-3.5.0-do-not-install-libopencl.patch"
	"${FILESDIR}/${PN}-5.3.3-gcc13.patch"
)

S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
S1="${WORKDIR}/ROCclr-rocm-${PV}"

src_prepare() {
	# Remove "clinfo" - use "dev-util/clinfo" instead
	[ -d tools/clinfo ] && rm -rf tools/clinfo || die

	cmake_src_prepare

	hprefixify amdocl/CMakeLists.txt

	sed -e "s/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g" -i packaging/CMakeLists.txt || die
	# remove trailing CR or it won't work
	sed -e "s/\r$//g" -i tests/ocltst/module/perf/oclperf.exclude || die

	pushd ${S1} || die
	# Bug #753377
	# patch re-enables accidentally disabled gfx800 family
	eapply "${FILESDIR}/${PN}-5.0.2-enable-gfx800.patch"
	eapply "${FILESDIR}/rocclr-5.3.3-fix-include.patch"
	eapply "${FILESDIR}/rocclr-5.3.3-gcc13.patch"
	popd || die
}

src_configure() {
	# Reported upstream: https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
	append-cflags -fcommon

	local mycmakeargs=(
		-Wno-dev
		-DROCCLR_PATH="${S1}"
		-DAMD_OPENCL_PATH="${S}"
		-DROCM_PATH="${EPREFIX}/usr"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DEMU_ENV=ON
		# -DCMAKE_STRIP=""
	)
	cmake_src_configure
}

src_install() {
	insinto /etc/OpenCL/vendors
	doins config/amdocl64.icd

	cd "${BUILD_DIR}" || die
	insinto /usr/lib64
	doins amdocl/libamdocl64.so
	doins tools/cltrace/libcltrace.so
}

# Copied from rocm.eclass. This ebuild does not need amdgpu_targets
# USE_EXPANDS, so it should not inherit rocm.eclass; it only uses the
# check_amdgpu function in src_test. Rename it to check-amdgpu to avoid
# pkgcheck warning.
check-amdgpu() {
	for device in /dev/kfd /dev/dri/render*; do
		addwrite ${device}
		if [[ ! -r ${device} || ! -w ${device} ]]; then
			eerror "Cannot read or write ${device}!"
			eerror "Make sure it is present and check the permission."
			ewarn "By default render group have access to it. Check if portage user is in render group."
			die "${device} inaccessible"
		fi
	done
}

src_test() {
	check-amdgpu
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
		./ocltst -m liboclgl.so -A ogl.exclude
		eend $? || die "oclgl test failed"
	else
		ewarn "${instruction1}"
		ewarn "${instruction2}"
		die "\${OCLGL_DISPLAY} not set."
	fi
	edob ./ocltst -m liboclruntime.so -A oclruntime.exclude
	edob ./ocltst -m liboclperf.so -A oclperf.exclude
}
