# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dist-kernel-utils.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Utility functions related to Distribution Kernels
# @DESCRIPTION:
# This eclass provides various utility functions related to Distribution
# Kernels.

# @ECLASS_VARIABLE: KERNEL_EFI_ZBOOT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, it is assumed the kernel was built with
# CONFIG_EFI_ZBOOT enabled. This effects the name of the kernel image on
# arm64 and riscv. Mainly useful for sys-kernel/gentoo-kernel-bin.

if [[ ! ${_DIST_KERNEL_UTILS} ]]; then

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit toolchain-funcs

# @FUNCTION: dist-kernel_get_image_path
# @DESCRIPTION:
# Get relative kernel image path specific to the current ${ARCH}.
dist-kernel_get_image_path() {
	case ${ARCH} in
		amd64|x86)
			echo arch/x86/boot/bzImage
			;;
		arm64|riscv)
			if [[ ${KERNEL_EFI_ZBOOT} ]]; then
				echo arch/${ARCH}/boot/vmlinuz.efi
			else
				echo arch/${ARCH}/boot/Image.gz
			fi
			;;
		loong)
			if [[ ${KERNEL_EFI_ZBOOT} ]]; then
				echo arch/loongarch/boot/vmlinuz.efi
			else
				echo arch/loongarch/boot/vmlinux.elf
			fi
			;;
		arm)
			echo arch/arm/boot/zImage
			;;
		hppa|ppc|ppc64|sparc)
			# https://www.kernel.org/doc/html/latest/powerpc/bootwrapper.html
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
	ARCH=$(tc-arch-kernel) installkernel "${version}" "${image}" "${map}"
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
	if [[ ! -f ${image_path} ]]; then
		eerror "Kernel install missing, image not found:"
		eerror "  ${image_path}"
		eerror "Initramfs will not be updated.  Please reinstall your kernel."
		return
	fi

	dist-kernel_install_kernel "${ver}" "${image_path}" \
		"${kernel_dir}/System.map"
}

# @FUNCTION: dist-kernel_PV_to_KV
# @USAGE: <pv>
# @DESCRIPTION:
# Convert a Gentoo-style ebuild version to kernel "x.y.z[-rcN]" version.
dist-kernel_PV_to_KV() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -ne 1 ]] && die "${FUNCNAME}: invalid arguments"
	local pv=${1}

	local kv=${pv%%_*}
	[[ -z $(ver_cut 3- "${kv}") ]] && kv+=".0"
	[[ ${pv} == *_* ]] && kv+=-${pv#*_}
	echo "${kv}"
}

# @FUNCTION: dist-kernel_compressed_module_cleanup
# @USAGE: <path>
# @DESCRIPTION:
# Traverse path for duplicate (un)compressed modules and remove all
# but the newest variant.
dist-kernel_compressed_module_cleanup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -ne 1 ]] && die "${FUNCNAME}: invalid arguments"
	local path=${1}
	local basename f

	while read -r basename; do
		local prev=
		for f in "${path}/${basename}"{,.gz,.xz,.zst}; do
			if [[ ! -e ${f} ]]; then
				continue
			elif [[ -z ${prev} ]]; then
				prev=${f}
			elif [[ ${f} -nt ${prev} ]]; then
				rm -v "${prev}" || die
				prev=${f}
			else
				rm -v "${f}" || die
			fi
		done
	done < <(
		cd "${path}" &&
		find -type f \
			\( -name '*.ko' \
			-o -name '*.ko.gz' \
			-o -name '*.ko.xz' \
			-o -name '*.ko.zst' \
			\) | sed -e 's:[.]\(gz\|xz\|zst\)$::' | sort | uniq -d || die
	)
}

_DIST_KERNEL_UTILS=1
fi
