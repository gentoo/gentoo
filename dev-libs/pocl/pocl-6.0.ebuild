# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {15..18} )
inherit cmake cuda llvm-r1

DESCRIPTION="Portable Computing Language (an implementation of OpenCL)"
HOMEPAGE="http://portablecl.org https://github.com/pocl/pocl"
SRC_URI="https://github.com/pocl/pocl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64"
# TODO: hsa tce
IUSE="accel +conformance cuda debug examples float-conversion hardening +hwloc memmanager test"
# Tests not yet passing, fragile in Portage environment(?)
RESTRICT="!test? ( test ) test"

CLANG_DEPS="
	$(llvm_gen_dep '
		!cuda? (
			sys-devel/clang:${LLVM_SLOT}=
			sys-devel/llvm:${LLVM_SLOT}=
		)
		cuda? (
			sys-devel/clang:${LLVM_SLOT}=[llvm_targets_NVPTX]
			sys-devel/llvm:${LLVM_SLOT}=[llvm_targets_NVPTX]
		)
	')
"
RDEPEND="
	${CLANG_DEPS}
	dev-libs/libltdl
	virtual/opencl
	debug? ( dev-util/lttng-ust:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	hwloc? ( sys-apps/hwloc:=[cuda?] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${CLANG_DEPS}
	virtual/pkgconfig
"

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
}

src_configure() {
	local host_cpu_variants="generic"

	if use amd64 ; then
		# Use pocl's curated list of CPU variants which should contain a good match for any given amd64 CPU
		host_cpu_variants="distro"
	elif use ppc64 ; then
		# A selection of architectures in which new Altivec / VSX features were added
		# This attempts to recreate the amd64 "distro" option for ppc64
		# See discussion in bug #831859
		host_cpu_variants="pwr10;pwr9;pwr8;pwr7;pwr6;g5;a2;generic"
	elif use riscv; then
		host_cpu_variants="generic-rv64"
	fi

	local mycmakeargs=(
		-DENABLE_HSA=OFF

		-DENABLE_ICD=ON
		-DPOCL_ICD_ABSOLUTE_PATH=ON
		-DPOCL_INSTALL_PUBLIC_LIBDIR="${EPREFIX}/usr/$(get_libdir)/OpenCL/vendors/pocl"

		# only appends -flto
		-DENABLE_IPO=OFF

		-DENABLE_POCL_BUILDING=ON
		-DKERNELLIB_HOST_CPU_VARIANTS="${host_cpu_variants}"

		-DSTATIC_LLVM=OFF
		-DWITH_LLVM_CONFIG=$(get_llvm_prefix -d)/bin/llvm-config

		-DENABLE_ALMAIF_DEVICE=$(usex accel)
		-DENABLE_CONFORMANCE=$(usex conformance)
		-DENABLE_CUDA=$(usex cuda)
		-DENABLE_HWLOC=$(usex hwloc)
		-DENABLE_POCL_FLOAT_CONVERSION=$(usex float-conversion)
		-DHARDENING_ENABLE=$(usex hardening)
		-DPOCL_DEBUG_MESSAGES=$(usex debug)
		-DUSE_POCL_MEMMANAGER=$(usex memmanager)
		-DENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	export POCL_BUILDING=1
	export POCL_DEVICES=basic
	export CTEST_OUTPUT_ON_FAILURE=1
	export TEST_VERBOSE=1

	# Referenced https://github.com/pocl/pocl/blob/master/.drone.yml
	# But couldn't seem to get tests working yet
	cmake_src_test
}

src_install() {
	cmake_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${P}/examples
	fi
}
