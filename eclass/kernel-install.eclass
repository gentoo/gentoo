# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kernel-install.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Installation mechanics for Distribution Kernels
# @DESCRIPTION:
# This eclass provides the logic needed to test and install different
# kinds of Distribution Kernel packages, including both kernels built
# from source and distributed as binaries.  The eclass relies on the
# ebuild installing a subset of built kernel tree into
# /usr/src/linux-${PV} containing the kernel image in its standard
# location and System.map.
#
# The eclass exports src_test, pkg_postinst and pkg_postrm.
# Additionally, the inherited mount-boot eclass exports pkg_pretend.
# It also stubs out pkg_preinst and pkg_prerm defined by mount-boot.

# @ECLASS-VARIABLE: KV_LOCALVERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the kernel LOCALVERSION, e.g. '-gentoo'.
# Needs to be set only when installing binary kernels,
# kernel-build.eclass obtains it from kernel config.

if [[ ! ${_KERNEL_INSTALL_ECLASS} ]]; then

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

inherit mount-boot toolchain-funcs

SLOT="${PV}"
IUSE="+initramfs test"
RESTRICT+="
	!test? ( test )
	test? ( userpriv )
	arm? ( test )
"

# install-DEPEND actually
# note: we need installkernel with initramfs support!
RDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( >=sys-kernel/dracut-049-r3 )"
BDEPEND="
	test? (
		dev-tcltk/expect
		sys-apps/coreutils
		sys-kernel/dracut
		sys-fs/e2fsprogs
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		arm64? ( app-emulation/qemu[qemu_softmmu_targets_aarch64] )
		ppc64? ( app-emulation/qemu[qemu_softmmu_targets_ppc64] )
		x86? ( app-emulation/qemu[qemu_softmmu_targets_i386] )
	)"

# @FUNCTION: kernel-install_build_initramfs
# @USAGE: <output> <version>
# @DESCRIPTION:
# Build an initramfs for the kernel.  <output> specifies the absolute
# path where initramfs will be created, while <version> specifies
# the kernel version, used to find modules.
kernel-install_build_initramfs() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "${FUNCNAME}: invalid arguments"
	local output=${1}
	local version=${2}

	ebegin "Building initramfs via dracut"
	dracut --force "${output}" "${version}"
	eend ${?} || die "Building initramfs failed"
}

# @FUNCTION: kernel-install_get_image_path
# @DESCRIPTION:
# Get relative kernel image path specific to the current ${ARCH}.
kernel-install_get_image_path() {
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

# @FUNCTION: kernel-install_install_kernel
# @USAGE: <version> <image> <system.map>
# @DESCRIPTION:
# Install kernel using installkernel tool.  <version> specifies
# the kernel version, <image> full path to the image, <system.map>
# full path to System.map.
kernel-install_install_kernel() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 3 ]] || die "${FUNCNAME}: invalid arguments"
	local version=${1}
	local image=${2}
	local map=${3}

	ebegin "Installing the kernel via installkernel"
	# note: .config is taken relatively to System.map;
	# initrd relatively to bzImage
	installkernel "${version}" "${image}" "${map}"
	eend ${?} || die "Installing the kernel failed"
}

# @FUNCTION: kernel-install_update_symlink
# @USAGE: <target> <version>
# @DESCRIPTION:
# Update the kernel source symlink at <target> (full path) with a link
# to <target>-<version> if it's either missing or pointing out to
# an older version of this package.
kernel-install_update_symlink() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 2 ]] || die "${FUNCNAME}: invalid arguments"
	local target=${1}
	local version=${2}

	if [[ ! -e ${target} ]]; then
		ebegin "Creating ${target} symlink"
		ln -f -n -s "${target##*/}-${version}" "${target}"
		eend ${?}
	else
		local symlink_target=$(readlink "${target}")
		local symlink_ver=${symlink_target#${target##*/}-}
		local updated=
		if [[ ${symlink_target} == ${target##*/}-* && \
				-z ${symlink_ver//[0-9.]/} ]]
		then
			local symlink_pkg=${CATEGORY}/${PN}-${symlink_ver}
			# if the current target is either being replaced, or still
			# installed (probably depclean candidate), update the symlink
			if has "${symlink_ver}" ${REPLACING_VERSIONS} ||
					has_version -r "~${symlink_pkg}"
			then
				ebegin "Updating ${target} symlink"
				ln -f -n -s "${target##*/}-${version}" "${target}"
				eend ${?}
				updated=1
			fi
		fi

		if [[ ! ${updated} ]]; then
			elog "${target} points at another kernel, leaving it as-is."
			elog "Please use 'eselect kernel' to update it when desired."
		fi
	fi
}

# @FUNCTION: kernel-install_get_qemu_arch
# @DESCRIPTION:
# Get appropriate qemu suffix for the current ${ARCH}.
kernel-install_get_qemu_arch() {
	debug-print-function ${FUNCNAME} "${@}"

	case ${ARCH} in
		amd64)
			echo x86_64
			;;
		x86)
			echo i386
			;;
		arm)
			echo arm
			;;
		arm64)
			echo aarch64
			;;
		ppc64)
			echo ppc64
			;;
		*)
			die "${FUNCNAME}: unsupported ARCH=${ARCH}"
			;;
	esac
}

# @FUNCTION: kernel-install_create_init
# @USAGE: <filename>
# @DESCRIPTION:
# Create minimal /sbin/init
kernel-install_create_init() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"
	[[ -z ${1} ]] && die "${FUNCNAME}: empty argument specified"

	local output="${1}"
	[[ -f ${output} ]] && die "${FUNCNAME}: ${output} already exists"

	cat <<-_EOF_ >"${T}/init.c" || die
		#include <stdio.h>
		int main() {
			printf("Hello, World!\n");
			return 0;
		}
	_EOF_

	$(tc-getBUILD_CC) -Os -static "${T}/init.c" -o "${output}" || die 
	$(tc-getBUILD_STRIP) "${output}" || die
}

# @FUNCTION: kernel-install_create_qemu_image
# @USAGE: <filename>
# @DESCRIPTION:
# Create minimal qemu raw image
kernel-install_create_qemu_image() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"
	[[ -z ${1} ]] && die "${FUNCNAME}: empty argument specified"

	local image="${1}"
	[[ -f ${image} ]] && die "${FUNCNAME}: ${image} already exists"

	local imageroot="${T}/imageroot"
	[[ -d ${imageroot} ]] && die "${FUNCNAME}: ${imageroot} already exists"
	mkdir "${imageroot}" || die

	# some layout needed to pass dracut's usable_root() validation
	mkdir -p "${imageroot}"/{bin,dev,etc,lib,proc,root,sbin,sys} || die
	touch "${imageroot}/lib/ld-fake.so" || die

	kernel-install_create_init "${imageroot}/sbin/init"

	# image may be smaller if needed
	truncate -s 4M "${image}" || die
	mkfs.ext4 -v -d "${imageroot}" -L groot "${image}" || die
}

# @FUNCTION: kernel-install_test
# @USAGE: <version> <image> <modules>
# @DESCRIPTION:
# Test that the kernel can successfully boot a minimal system image
# in qemu.  <version> is the kernel version, <image> path to the image,
# <modules> path to module tree.
kernel-install_test() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 3 ]] || die "${FUNCNAME}: invalid arguments"
	local version=${1}
	local image=${2}
	local modules=${3}

	local qemu_arch=$(kernel-install_get_qemu_arch)

	dracut \
		--conf /dev/null \
		--confdir /dev/null \
		--no-hostonly \
		--kmoddir "${modules}" \
		"${T}/initrd" "${version}" || die

	kernel-install_create_qemu_image "${T}/fs.img"

	cd "${T}" || die

	local qemu_extra_args=
	local qemu_extra_append=

	case ${qemu_arch} in
		aarch64)
			qemu_extra_args="-M virt -cpu cortex-a57 -smp 1"
			qemu_extra_append="console=ttyAMA0"
			;;
		i386|x86_64)
			qemu_extra_args="-cpu max"
			qemu_extra_append="console=ttyS0,115200n8"
			;;
		ppc64)
			qemu_extra_args="-nodefaults"
			;;
		*)
			:
			;;
	esac

	cat > run.sh <<-EOF || die
		#!/bin/sh
		exec qemu-system-${qemu_arch} \
			${qemu_extra_args} \
			-m 512M \
			-nographic \
			-no-reboot \
			-kernel '${image}' \
			-initrd '${T}/initrd' \
			-serial mon:stdio \
			-drive file=fs.img,format=raw,index=0,media=disk \
			-append 'root=LABEL=groot ${qemu_extra_append}'
	EOF
	chmod +x run.sh || die
	# TODO: initramfs does not let core finish starting on some systems,
	# figure out how to make it better at that
	expect - <<-EOF || die "Booting kernel failed"
		set timeout 900
		spawn ./run.sh
		expect {
			"terminating on signal" {
				send_error "\n* Qemu killed"
				exit 1
			}
			"OS terminated" {
				send_error "\n* Qemu terminated OS"
				exit 1
			}
			"Kernel panic" {
				send_error "\n* Kernel panic"
				exit 1
			}
			"Entering emergency mode" {
				send_error "\n* Initramfs failed to start the system"
				exit 1
			}
			"Hello, World!" {
				send_error "\n* Booted successfully"
				exit 0
			}
			timeout {
				send_error "\n* Kernel boot timed out"
				exit 2
			}
		}
	EOF
}

# @FUNCTION: kernel-install_pkg_pretend
# @DESCRIPTION:
# Check for missing optional dependencies and output warnings.
kernel-install_pkg_pretend() {
	debug-print-function ${FUNCNAME} "${@}"

	if ! has_version -d sys-kernel/linux-firmware; then
		ewarn "sys-kernel/linux-firmware not found installed on your system."
		ewarn "This package provides various firmware files that may be needed"
		ewarn "for your hardware to work.  If in doubt, it is recommended"
		ewarn "to pause or abort the build process and install it before"
		ewarn "resuming."

		if use initramfs; then
			elog
			elog "If you decide to install linux-firmware later, you can rebuild"
			elog "the initramfs via issuing a command equivalent to:"
			elog
			elog "    emerge --config ${CATEGORY}/${PN}"
		fi
	fi
}

# @FUNCTION: kernel-install_src_test
# @DESCRIPTION:
# Boilerplate function to remind people to call the tests.
kernel-install_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	die "Please redefine src_test() and call kernel-install_test()."
}

# @FUNCTION: kernel-install_pkg_preinst
# @DESCRIPTION:
# Stub out mount-boot.eclass.
kernel-install_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"

	# (no-op)
}

# @FUNCTION: kernel-install_pkg_postinst
# @DESCRIPTION:
# Build an initramfs for the kernel, install it and update
# the /usr/src/linux symlink.
kernel-install_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${ROOT} ]]; then
		mount-boot_pkg_preinst

		local ver="${PV}${KV_LOCALVERSION}"
		local image_path=$(kernel-install_get_image_path)
		if use initramfs; then
			# putting it alongside kernel image as 'initrd' makes
			# kernel-install happier
			kernel-install_build_initramfs \
				"${EROOT}/usr/src/linux-${ver}/${image_path%/*}/initrd" \
				"${ver}"
		fi

		kernel-install_install_kernel "${ver}" \
			"${EROOT}/usr/src/linux-${ver}/${image_path}" \
			"${EROOT}/usr/src/linux-${ver}/System.map"
	fi

	kernel-install_update_symlink "${EROOT}/usr/src/linux" "${ver}"
}

# @FUNCTION: kernel-install_pkg_prerm
# @DESCRIPTION:
# Stub out mount-boot.eclass.
kernel-install_pkg_prerm() {
	debug-print-function ${FUNCNAME} "${@}"

	# (no-op)
}

# @FUNCTION: kernel-install_pkg_postrm
# @DESCRIPTION:
# No-op at the moment.  Will be used to remove obsolete kernels
# in the future.
kernel-install_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${ROOT} ]] && use initramfs; then
		local ver="${PV}${KV_LOCALVERSION}"
		local image_path=$(kernel-install_get_image_path)
		ebegin "Removing initramfs"
		rm -f "${EROOT}/usr/src/linux-${ver}/${image_path%/*}/initrd" &&
			find "${EROOT}/usr/src/linux-${ver}" -depth -type d -empty -delete
		eend ${?}
	fi
}

# @FUNCTION: kernel-install_pkg_config
# @DESCRIPTION:
# Rebuild the initramfs and reinstall the kernel.
kernel-install_pkg_config() {
	[[ -z ${ROOT} ]] || die "ROOT!=/ not supported currently"

	mount-boot_pkg_preinst

	local ver="${PV}${KV_LOCALVERSION}"
	local image_path=$(kernel-install_get_image_path)
	if use initramfs; then
		# putting it alongside kernel image as 'initrd' makes
		# kernel-install happier
		kernel-install_build_initramfs \
			"${EROOT}/usr/src/linux-${ver}/${image_path%/*}/initrd" \
			"${ver}"
	fi

	kernel-install_install_kernel "${ver}" \
		"${EROOT}/usr/src/linux-${ver}/${image_path}" \
		"${EROOT}/usr/src/linux-${ver}/System.map"
}

_KERNEL_INSTALL_ECLASS=1
fi

EXPORT_FUNCTIONS src_test pkg_preinst pkg_postinst pkg_prerm pkg_postrm
EXPORT_FUNCTIONS pkg_config pkg_pretend
