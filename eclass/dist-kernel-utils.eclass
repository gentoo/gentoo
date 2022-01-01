# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dist-kernel-utils.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Utility functions related to Distribution Kernels
# @DESCRIPTION:
# This eclass provides various utility functions related to Distribution
# Kernels.

if [[ ! ${_DIST_KERNEL_UTILS} ]]; then

case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @FUNCTION: dist-kernel_build_initramfs
# @USAGE: <output> <version>
# @DESCRIPTION:
# Build an initramfs for the kernel.  <output> specifies the absolute
# path where initramfs will be created, while <version> specifies
# the kernel version, used to find modules.
#
# Note: while this function uses dracut at the moment, other initramfs
# variants may be supported in the future.
dist-kernel_build_initramfs() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "${FUNCNAME}: invalid arguments"
	local output=${1}
	local version=${2}

	ebegin "Building initramfs via dracut"
	dracut --force "${output}" "${version}"
	eend ${?} || die -n "Building initramfs failed"
}

# @FUNCTION: dist-kernel_get_image_path
# @DESCRIPTION:
# Get relative kernel image path specific to the current ${ARCH}.
dist-kernel_get_image_path() {
	case ${ARCH} in
		amd64|x86)
			echo arch/x86/boot/bzImage
			;;
		arm64)
			echo arch/arm64/boot/Image.gz
			;;
		arm)
			echo arch/arm/boot/zImage
			;;
		ppc64)
			# ./ is required because of ${image_path%/*}
			# substitutions in the code
			echo ./vmlinux
			;;
		*)
			die "${FUNCNAME}: unsupported ARCH=${ARCH}"
			;;
	esac
}

# @FUNCTION: dist-kernel_install_kernel
# @USAGE: <version> <image> <system.map>
# @DESCRIPTION:
# Install kernel using installkernel tool.  <version> specifies
# the kernel version, <image> full path to the image, <system.map>
# full path to System.map.
dist-kernel_install_kernel() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 3 ]] || die "${FUNCNAME}: invalid arguments"
	local version=${1}
	local image=${2}
	local map=${3}

	ebegin "Installing the kernel via installkernel"
	# note: .config is taken relatively to System.map;
	# initrd relatively to bzImage
	installkernel "${version}" "${image}" "${map}"
	eend ${?} || die -n "Installing the kernel failed"
}

# @FUNCTION: dist-kernel_reinstall_initramfs
# @USAGE: <kv-dir> <kv-full>
# @DESCRIPTION:
# Rebuild and install initramfs for the specified dist-kernel.
# <kv-dir> is the kernel source directory (${KV_DIR} from linux-info),
# while <kv-full> is the full kernel version (${KV_FULL}).
# The function will determine whether <kernel-dir> is actually
# a dist-kernel, and whether initramfs was used.
#
# This function is to be used in pkg_postinst() of ebuilds installing
# kernel modules that are included in the initramfs.
dist-kernel_reinstall_initramfs() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "${FUNCNAME}: invalid arguments"
	local kernel_dir=${1}
	local ver=${2}

	local image_path=${kernel_dir}/$(dist-kernel_get_image_path)
	local initramfs_path=${image_path%/*}/initrd
	if [[ ! -f ${image_path} ]]; then
		eerror "Kernel install missing, image not found:"
		eerror "  ${image_path}"
		eerror "Initramfs will not be updated.  Please reinstall your kernel."
		return
	fi
	if [[ ! -f ${initramfs_path} ]]; then
		einfo "No initramfs found at ${initramfs_path}"
		return
	fi

	dist-kernel_build_initramfs "${initramfs_path}" "${ver}"
	dist-kernel_install_kernel "${ver}" "${image_path}" \
		"${kernel_dir}/System.map"
}

_DIST_KERNEL_UTILS=1
fi
