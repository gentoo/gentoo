# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rocm.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @AUTHOR:
# Yiyang Wu <xgreenlandforwyy@gmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for ROCm packages written in HIP
# @DESCRIPTION:
# ROCm packages such as sci-libs/<roc|hip>*, and packages built on top of ROCm
# libraries, can utilize variables and functions provided by this eclass.
# It handles the AMDGPU_TARGETS variable via USE_EXPAND, so user can
# edit USE flag to control which GPU architecture to compile. Using
# ${ROCM_USEDEP} can ensure coherence among dependencies. Ebuilds can call the
# function get_amdgpu_flag to translate activated target to GPU compile flags,
# passing it to configuration. Function rocm_use_hipcc switches active compiler
# to hipcc and cleans incompatible flags (useful for users with gcc-only flags
# in /etc/portage/make.conf). Function check_amdgpu can help ebuild ensure
# read and write permissions to GPU device in src_test phase, throwing friendly
# error message if unavailable. However src_configure in general should not
# access any AMDGPU devices. If it does, it usually means that CMakeLists.txt
# ignores AMDGPU_TARGETS in favor of autodetected GPU, which is not desired.
#
# @EXAMPLE:
# Example ebuild for ROCm library in https://github.com/ROCmSoftwarePlatform
# which uses cmake to build and test, and depends on rocBLAS:
# @CODE
# ROCM_VERSION=${PV}
# inherit cmake rocm
# # ROCm libraries SRC_URI is usually in form of:
# SRC_URI="https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
# S=${WORKDIR}/${PN}-rocm-${PV}
# SLOT="0/$(ver_cut 1-2)"
# IUSE="test"
# REQUIRED_USE="${ROCM_REQUIRED_USE}"
# RESTRICT="!test? ( test )"
#
# RDEPEND="
#     dev-util/hip
#     sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
# "
#
# src_configure() {
#     rocm_use_hipcc
#     local mycmakeargs=(
#         -DAMDGPU_TARGETS="$(get_amdgpu_flags)"
#         -DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
#     )
#     cmake_src_configure
# }
#
# src_test() {
#     check_amdgpu
#     # export LD_LIBRARY_PATH=<path to built lib dir> if necessary
#     cmake_src_test # for packages using the cmake test
#     # For packages using a standalone test binary rather than cmake test,
#     # just execute it (or using edob)
# }
# @CODE
#
# Examples for packages depend on ROCm libraries -- a package which depends on
# rocBLAS, uses comma separated ${HCC_AMDGPU_TARGET} to determine GPU
# architectures, and requires ROCm version >=5.1
# @CODE
# ROCM_VERSION=5.1
# inherit rocm
# IUSE="rocm"
# REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"
# DEPEND="rocm? ( >=dev-util/hip-${ROCM_VERSION}
#     >=sci-libs/rocBLAS-${ROCM_VERSION}[${ROCM_USEDEP}] )"
#
# src_configure() {
#     if use rocm; then
#         local amdgpu_flags=$(get_amdgpu_flags)
#         export HCC_AMDGPU_TARGET=${amdgpu_flags//;/,}
#     fi
#     default
# }
# src_test() {
#     use rocm && check_amdgpu
#     default
# }
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ROCM_ECLASS} ]]; then
_ROCM_ECLASS=1

inherit flag-o-matic

# @ECLASS_VARIABLE: ROCM_VERSION
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# The ROCm version of current package. For ROCm libraries, it should be ${PV};
# for other packages that depend on ROCm libraries, this can be set to match
# the version required for ROCm libraries.

# @ECLASS_VARIABLE: ROCM_REQUIRED_USE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Requires at least one AMDGPU target to be compiled.
# Example use for ROCm libraries:
# @CODE
# REQUIRED_USE="${ROCM_REQUIRED_USE}"
# @CODE
# Example use for packages that depend on ROCm libraries:
# @CODE
# IUSE="rocm"
# REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"
# @CODE

# @ECLASS_VARIABLE: ROCM_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another ROCm package being built for the same AMDGPU architecture.
#
# The generated USE-flag list is compatible with packages using rocm.eclass.
#
# Example use:
# @CODE
# DEPEND="sci-libs/rocBLAS[${ROCM_USEDEP}]"
# @CODE

# @ECLASS_VARIABLE: ROCM_SKIP_GLOBALS
# @DESCRIPTION:
# Controls whether _rocm_set_globals() is executed. This variable is for
# ebuilds that call check_amdgpu() without the need to define amdgpu_targets_*
# USE-flags, such as dev-util/hip and dev-libs/rocm-opencl-runtime.
#
# Example use:
# @CODE
# ROCM_SKIP_GLOBALS=1
# inherit rocm
# @CODE

# @FUNCTION: _rocm_set_globals
# @DESCRIPTION:
# Set global variables useful to ebuilds: IUSE, ROCM_REQUIRED_USE, and
# ROCM_USEDEP, unless ROCM_SKIP_GLOBALS is set.

_rocm_set_globals() {
	[[ -n ${ROCM_SKIP_GLOBALS} ]] && return

	# Two lists of AMDGPU_TARGETS of certain ROCm version.  Official support
	# matrix:
	# https://docs.amd.com/bundle/ROCm-Installation-Guide-v${ROCM_VERSION}/page/Prerequisite_Actions.html.
	# There is no well-known unofficial support matrix.
	# https://github.com/Bengt/ROCm/blob/patch-2/README.md#library-target-matrix
	# may help. Gentoo have patches to enable gfx1031 as well.
	local unofficial_amdgpu_targets official_amdgpu_targets
	case ${ROCM_VERSION} in
		5.[0-3].*)
			unofficial_amdgpu_targets=(
				gfx803 gfx900 gfx1010 gfx1011 gfx1012 gfx1031
			)
			official_amdgpu_targets=(
				gfx906 gfx908 gfx90a gfx1030
			)
			;;
		5.*)
			unofficial_amdgpu_targets=(
				gfx803 gfx900 gfx1010 gfx1011 gfx1012
				gfx1031 gfx1100 gfx1101 gfx1102
			)
			official_amdgpu_targets=(
				gfx906 gfx908 gfx90a gfx1030
			)
			;;
		6.*|9999)
			unofficial_amdgpu_targets=(
				gfx803 gfx900 gfx940 gfx941
				gfx1010 gfx1011 gfx1012
				gfx1031 gfx1101 gfx1102
			)
			official_amdgpu_targets=(
				gfx906 gfx908 gfx90a gfx942 gfx1030 gfx1100
			)
			;;
		*)
			die "Unknown ROCm major version! Please update rocm.eclass before bumping to new ebuilds"
			;;
	esac

	local iuse_flags=(
		"${official_amdgpu_targets[@]/#/+amdgpu_targets_}"
		"${unofficial_amdgpu_targets[@]/#/amdgpu_targets_}"
	)
	IUSE="${iuse_flags[*]}"

	local all_amdgpu_targets=(
		"${official_amdgpu_targets[@]}"
		"${unofficial_amdgpu_targets[@]}"
	)
	local allflags=( "${all_amdgpu_targets[@]/#/amdgpu_targets_}" )
	ROCM_REQUIRED_USE=" || ( ${allflags[*]} )"

	local optflags=${allflags[@]/%/(-)?}
	ROCM_USEDEP=${optflags// /,}
}
_rocm_set_globals
unset -f _rocm_set_globals

# @FUNCTION: get_amdgpu_flags
# @USAGE: get_amdgpu_flags
# @DESCRIPTION:
# Convert specified use flag of amdgpu_targets to compilation flags.
# Append default target feature to GPU arch. See
# https://llvm.org/docs/AMDGPUUsage.html#target-features
get_amdgpu_flags() {
	echo $(printf "%s;" ${AMDGPU_TARGETS[@]})
}

# @FUNCTION: check_amdgpu
# @USAGE: check_amdgpu
# @DESCRIPTION:
# grant and check read-write permissions on AMDGPU devices, die if not available.
check_amdgpu() {
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

fi

# @FUNCTION: rocm_use_hipcc
# @USAGE: rocm_use_hipcc
# @DESCRIPTION:
# switch active C and C++ compilers to hipcc, clean unsupported flags and setup ROCM_TARGET_LST file.
rocm_use_hipcc() {
	# During the configuration stage, CMake tests whether the compiler is able to compile a simple program.
	# Since CMake checker does not specify --offload-arch=, hipcc enumerates devices using four methods
	# until it finds at least one device. Last way is by accessing them (via rocminfo).
	# To prevent potential sandbox violations, we set the ROCM_TARGET_LST variable (which is checked first).
	local target_lst="${T}"/gentoo_rocm_target.lst
	if [[ "${AMDGPU_TARGETS[@]}" = "" ]]; then
		# Expected no GPU code; still need to calm down sandbox
		echo "gfx000" > "${target_lst}" || die
	else
		printf "%s\n" ${AMDGPU_TARGETS[@]} > "${target_lst}" || die
	fi
	export ROCM_TARGET_LST="${target_lst}"

	# Export updated CC and CXX. Note that CC is needed even if no C code used,
	# as CMake checks that C compiler can compile a simple test program.
	export CC=hipcc CXX=hipcc
	strip-unsupported-flags
}
