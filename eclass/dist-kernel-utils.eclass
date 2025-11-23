# Copyright 2020-2025 Gentoo Authors
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

inherit mount-boot-utils toolchain-funcs

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
# @USAGE: [<version>] [<image>] [<system.map>] [<dir>] [<installkernel-args>...]
# @DESCRIPTION:
# Install kernel using installkernel. Takes the following arguments:
#
# <version> -- the target kernel version (default: ${KV_FULL})
#
# <image> -- the full path to the kernel image (default: the image
# 	 	as reported by dist-kernel_get_image_path() in the ${KV_DIR})
#
# <system.map> -- the full path to the System.map
# 		(default: ${KV_DIR}/System.map})
#
# <dir> -- the target directory to install to (default: ${EROOT}/boot)
#
# <installkernel-args> -- extra optional arguments for installkernel
# 		see man kernel-install and man installkernel. Requires at
# 		least version 56 of sys-kernel/installkernel.
dist-kernel_install_kernel() {
	debug-print-function ${FUNCNAME} "$@"

	local version=${1:-${KV_FULL}}
	local image=${2:-${KV_DIR}/$(dist-kernel_get_image_path)}
	local map=${3:-${KV_DIR}/System.map}
	local dir=${4:-${EROOT}/boot}

	local installkernel_args=(
		"${version}" "${image}" "${map}" "${dir}"
	)
	if has_version ">=sys-kernel/installkernel-56"; then
		installkernel_args+=( "${@:5}" --verbose )
	fi

	local success=
	# not an actual loop but allows error handling with 'break'
	while true; do
		if [[ -n ${ROOT} ]] && in_iuse initramfs && use initramfs; then
			if ! in_iuse generic-uki || ! use generic-uki; then
				eerror
				eerror "ROOT is set, and (re-)generation of an initramfs is requested"
				eerror "via the USE=initramfs flag. However, this is currently not"
				eerror "supported via the sys-kernel/installkernel mechanism."
				eerror
				if in_iuse generic-uki && ! use generic-uki; then
					eerror "Generation and installation of a generic initramfs and/or"
					eerror "Unified Kernel Image is possible via portage by enabling the"
					eerror "USE=generic-uki flag. Please enable the generic-uki flag, or"
					eerror "chroot into: ROOT=${ROOT}"
				else
					eerror "Please chroot into: ROOT=${ROOT}"
				fi
				break
			fi
		fi

		nonfatal mount-boot_check_status || break
		mkdir -p "${EROOT}/boot" || break

		ebegin "Installing the kernel via installkernel"
		# note: .config is taken relatively to System.map;
		# initrd relatively to bzImage
		ARCH=$(tc-arch-kernel) installkernel "${installkernel_args[@]}" || break
		eend ${?} || die -n "Installing the kernel failed"

		success=1
		break
	done

	if [[ ! ${success} ]]; then
		# Fallback string, if the identifier file is not found
		local kernel="<name of your kernel pakcage>:<kernel version>"
		# Try to read dist-kernel identifier to more accurately instruct users
		local k_id_file=${image%$(dist-kernel_get_image_path)}/dist-kernel
		if [[ -f ${k_id_file} ]]; then
			kernel=\'\=$(<${k_id_file})\'
		fi

		eerror
		eerror "The kernel was not deployed successfully. Inspect the failure"
		eerror "in the logs above and once you resolve the problems please"
		eerror "run the equivalent of the following command to try again:"
		eerror
		if has --all "${installkernel_args[@]}"; then
			eerror "    installkernel ${installkernel_args[*]}"
		else
			eerror "    emerge --config ${kernel}"
		fi
		die "Kernel install failed, please fix the problems and run emerge --config"
	fi
}

# @FUNCTION: dist-kernel_reinstall_initramfs
# @USAGE: [<kv-dir>] [<kv-full>] [<installkernel-args>...]
# @DESCRIPTION:
# Rebuild and install initramfs for the specified dist-kernel.
# Takes the following arguments:
#
# <kv-dir> -- the full path to the target kernel (default: ${KV_DIR})
#
# <kv-full> -- the target kernel version (default: ${KV_FULL})
#
# <installkernel-args> -- extra optional arguments for installkernel
# 		see man kernel-install and man installkernel. Requires at
# 		least version 56 of sys-kernel/installkernel.
#
# This function is to be used in pkg_postinst() of ebuilds installing
# kernel modules that are included in the initramfs. In order to
# reinstall *all* distribution kernels currently installed on the
# system add the --all argument (requires installkernel-56 or newer).
dist-kernel_reinstall_initramfs() {
	debug-print-function ${FUNCNAME} "$@"

	local kernel_dir=${1:-${KV_DIR}}
	local ver=${2:-${KV_FULL}}

	# If this is set it will have an effect on the name of the output
	# image. Set this variable to track this setting.
	if grep -q "CONFIG_EFI_ZBOOT=y" "${kernel_dir}/.config"; then
		KERNEL_EFI_ZBOOT=1
	fi

	local image_path=${kernel_dir}/$(dist-kernel_get_image_path)

	if [[ ! -f ${image_path} ]]; then
		eerror "Kernel install missing, image not found:"
		eerror "  ${image_path}"
		eerror "Initramfs will not be updated.  Please reinstall kernel ${ver}."
		return
	fi

	dist-kernel_install_kernel "${ver}" "${image_path}" \
		"${kernel_dir}/System.map" "${EROOT}/boot" "${@:3}"
}

# @FUNCTION: dist-kernel_PV_to_KV
# @USAGE: <pv>
# @DESCRIPTION:
# Convert a Gentoo-style ebuild version to kernel "x.y.z[-rcN]" version.
dist-kernel_PV_to_KV() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 1 ]] && die "${FUNCNAME}: invalid arguments"
	local pv=${1}

	local kv=${pv%%_*}
	[[ -z $(ver_cut 3- "${kv}") ]] && kv+=".0"
	[[ ${pv} == *_* ]] && kv+=-${pv#*_}
	echo "${kv}"
}

# @FUNCTION: dist-kernel_get_module_suffix
# @USAGE: <kernel_config>
# @DESCRIPTION:
# Returns the suffix for kernel modules based on the CONFIG_MODULES_COMPESS_*
# setting in the kernel config and USE=modules-compress.
dist-kernel_get_module_suffix() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"

	local config=${1}

	if ! in_iuse modules-compress || ! use modules-compress; then
		echo .ko
	elif [[ ! -r ${config} ]]; then
		die "Cannot find kernel config ${config}"
	elif grep -q "CONFIG_MODULE_COMPRESS_NONE=y" "${config}" ||
		grep -q "# CONFIG_MODULE_COMPRESS is not set" "${config}"; then
		echo .ko
	elif grep -q "CONFIG_MODULE_COMPRESS_GZIP=y" "${config}"; then
		echo .ko.gz
	elif grep -q "CONFIG_MODULE_COMPRESS_XZ=y" "${config}"; then
		echo .ko.xz
	elif grep -q "CONFIG_MODULE_COMPRESS_ZSTD=y" "${config}"; then
		echo .ko.zst
	else
		die "Module compression is enabled, but compressor not known"
	fi
}

# @FUNCTION: dist-kernel_compressed_module_cleanup
# @USAGE: <path>
# @DESCRIPTION:
# Traverse path for duplicate (un)compressed modules and remove all
# but the newest variant.
dist-kernel_compressed_module_cleanup() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 1 ]] && die "${FUNCNAME}: invalid arguments"
	local path=${1}
	local config_path=/usr/src/linux-${KV_FULL}/.config

	local option
	for option in config source/.config build/.config; do
		if [[ -f ${path}/${option} ]]; then
			config_path=${path}/${option}
			break
		fi
	done

	local preferred=
	[[ -f ${config_path} ]] && preferred=$(dist-kernel_get_module_suffix "${config_path}")

	local basename suffix

	while read -r basename; do
		local prev=
		for suffix in .ko .ko.gz .ko.xz .ko.zst; do
			[[ ${suffix} == ${preferred} ]] && continue
			local current=${path}/${basename}${suffix}
			[[ -f ${current} ]] || continue

			if [[ -f ${path}/${basename}${preferred} ]]; then
				# If the module with the desired compression exists, remove
				# all other variations.
				rm -v "${current}" || die
			elif [[ -z ${prev} ]]; then
				# If not, then keep whichever of the duplicate modules is the
				# newest. Normally you should not end up here.
				prev=${current}
			elif [[ ${current} -nt ${prev} ]]; then
				rm -v "${prev}" || die
				prev=${current}
			else
				rm -v "${current}" || die
			fi
		done
	done < <(
		cd "${path}" &&
		find -type f \
			\( -name '*.ko' \
			-o -name '*.ko.gz' \
			-o -name '*.ko.xz' \
			-o -name '*.ko.zst' \
			\) | sed -e 's:[.]ko\(\|[.]gz\|[.]xz\|[.]zst\)$::' |
				sort | uniq -d || die
	)
}

_DIST_KERNEL_UTILS=1
fi
