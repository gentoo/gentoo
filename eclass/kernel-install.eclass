# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kernel-install.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: dist-kernel-utils
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

# @ECLASS_VARIABLE: KV_LOCALVERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the kernel LOCALVERSION, e.g. '-gentoo'.
# Needs to be set only when installing binary kernels,
# kernel-build.eclass obtains it from kernel config.

if [[ ! ${_KERNEL_INSTALL_ECLASS} ]]; then
_KERNEL_INSTALL_ECLASS=1

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit dist-kernel-utils mount-boot toolchain-funcs

SLOT="${PV}"
IUSE="+initramfs test"
RESTRICT+="
	!test? ( test )
	test? ( userpriv )
	arm? ( test )
"

# note: we need installkernel with initramfs support!
IDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( >=sys-kernel/dracut-049-r3 )"
# needed by objtool that is installed along with the kernel and used
# to build external modules
# NB: linux-mod.eclass also adds this dep but it's cleaner to have
# it here, and resolves QA warnings: https://bugs.gentoo.org/732210
RDEPEND+="
	virtual/libelf"
BDEPEND="
	test? (
		dev-tcltk/expect
		sys-apps/coreutils
		sys-kernel/dracut
		sys-fs/e2fsprogs
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		arm64? ( app-emulation/qemu[qemu_softmmu_targets_aarch64] )
		ppc? ( app-emulation/qemu[qemu_softmmu_targets_ppc] )
		ppc64? ( app-emulation/qemu[qemu_softmmu_targets_ppc64] )
		x86? ( app-emulation/qemu[qemu_softmmu_targets_i386] )
	)"

# @FUNCTION: kernel-install_can_update_symlink
# @USAGE:
# @DESCRIPTION:
# Determine whether the symlink at <target> (full path) should be
# updated.  Returns 0 if it should, 1 to leave as-is.
kernel-install_can_update_symlink() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"
	local target=${1}

	# if the symlink does not exist or is broken, update
	[[ ! -e ${target} ]] && return 0
	# if the target does not seem to contain kernel sources
	# (i.e. is probably a leftover directory), update
	[[ ! -e ${target}/Makefile ]] && return 0

	local symlink_target=$(readlink "${target}")
	# the symlink target should start with the same basename as target
	# (e.g. "linux-*")
	[[ ${symlink_target} != ${target##*/}-* ]] && return 1

	# try to establish the kernel version from symlink target
	local symlink_ver=${symlink_target#${target##*/}-}
	# strip KV_LOCALVERSION, we want to update the old kernels not using
	# KV_LOCALVERSION suffix and the new kernels using it
	symlink_ver=${symlink_ver%${KV_LOCALVERSION}}

	# if ${symlink_ver} contains anything but numbers (e.g. an extra
	# suffix), it's not our kernel, so leave it alone
	[[ -n ${symlink_ver//[0-9.]/} ]] && return 1

	local symlink_pkg=${CATEGORY}/${PN}-${symlink_ver}
	# if the current target is either being replaced, or still
	# installed (probably depclean candidate), update the symlink
	has "${symlink_ver}" ${REPLACING_VERSIONS} && return 0
	has_version -r "~${symlink_pkg}" && return 0

	# otherwise it could be another kernel package, so leave it alone
	return 1
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

	if kernel-install_can_update_symlink "${target}"; then
		ebegin "Updating ${target} symlink"
		ln -f -n -s "${target##*/}-${version}" "${target}"
		eend ${?}
	else
		elog "${target} points at another kernel, leaving it as-is."
		elog "Please use 'eselect kernel' to update it when desired."
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
		ppc)
			echo ppc
			;;
		ppc64)
			echo ppc64
			;;
		riscv)
			echo riscv
			;;
		sparc)
			echo sparc
			;;
		sparc64)
			echo sparc64
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
		#include <sys/utsname.h>

		int main() {
			struct utsname u;
			int ret = uname(&u);
			if (ret != 0) {
				printf("uname() failed, but that's fine\n");
			}
			else {
				// Booted: Linux 5.10.47 ppc64le #1 SMP Fri Jul 2 12:55:24 PDT 2021
				printf("Booted: %s %s %s %s\n", u.sysname, u.release,
						u.machine, u.version);
			}

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

	# some modules may complicate or even fail the test boot
	local omit_mods=(
		crypt dm dmraid lvm mdraid multipath nbd # no need for blockdev tools
		network network-manager # no need for network
		btrfs cifs nfs zfs zfsexpandknowledge # we don't need it
		plymouth # hangs, or sometimes steals output
		rngd # hangs or segfaults sometimes
		i18n # copies all the fonts from /usr/share/consolefonts
	)

	# NB: if you pass a path that does not exist or is not a regular
	# file/directory, dracut will silently ignore it and use the default
	# https://github.com/dracutdevs/dracut/issues/1136
	> "${T}"/empty-file || die
	mkdir -p "${T}"/empty-directory || die

	dracut \
		--conf "${T}"/empty-file \
		--confdir "${T}"/empty-directory \
		--no-hostonly \
		--kmoddir "${modules}" \
		--force-add "qemu" \
		--omit "${omit_mods[*]}" \
		--nostrip \
		--no-early-microcode \
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
		ppc)
			# https://wiki.qemu.org/Documentation/Platforms/PowerPC#Command_line_options
			qemu_extra_args="-boot d -L pc-bios -M mac99,via=pmu"
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
				send_error "\n* Qemu killed\n"
				exit 1
			}
			"OS terminated" {
				send_error "\n* Qemu terminated OS\n"
				exit 1
			}
			"Kernel panic" {
				send_error "\n* Kernel panic\n"
				exit 1
			}
			"Entering emergency mode" {
				send_error "\n* Initramfs failed to start the system\n"
				exit 1
			}
			"Hello, World!" {
				send_error "\n* Booted successfully\n"
				exit 0
			}
			timeout {
				send_error "\n* Kernel boot timed out\n"
				exit 2
			}
			eof {
				send_error "\n* qemu terminated before booting the kernel\n"
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
			elog "    emerge --config ${CATEGORY}/${PN}:${SLOT}"
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
# Verify whether the kernel has been installed correctly.
kernel-install_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"

	local dir_ver=${PV}${KV_LOCALVERSION}
	local kernel_dir=${ED}/usr/src/linux-${dir_ver}
	local relfile=${kernel_dir}/include/config/kernel.release
	[[ ! -d ${kernel_dir} ]] &&
		die "Kernel directory ${kernel_dir} not installed!"
	[[ ! -f ${relfile} ]] &&
		die "Release file ${relfile} not installed!"
	local release
	release="$(<"${relfile}")" || die

	# perform the version check for release ebuilds only
	if [[ ${PV} != *9999 ]]; then
		local expected_ver=$(dist-kernel_PV_to_KV "${PV}")

		if [[ ${release} != ${expected_ver}* ]]; then
			eerror "Kernel release mismatch!"
			eerror "  expected (PV): ${expected_ver}*"
			eerror "          found: ${release}"
			eerror "Please verify that you are applying the correct patches."
			die "Kernel release mismatch (${release} instead of ${expected_ver}*)"
		fi
	fi

	if [[ -L ${EROOT}/lib && ${EROOT}/lib -ef ${EROOT}/usr/lib ]]; then
		# Adjust symlinks for merged-usr.
		rm "${ED}/lib/modules/${release}"/{build,source} || die
		dosym "../../../src/linux-${dir_ver}" "/usr/lib/modules/${release}/build"
		dosym "../../../src/linux-${dir_ver}" "/usr/lib/modules/${release}/source"
	fi
}

# @FUNCTION: kernel-install_install_all
# @USAGE: <ver>
# @DESCRIPTION:
# Build an initramfs for the kernel and install the kernel.  This is
# called from pkg_postinst() and pkg_config().  <ver> is the full
# kernel version.
kernel-install_install_all() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"
	local dir_ver=${1}
	local kernel_dir=${EROOT}/usr/src/linux-${dir_ver}
	local relfile=${kernel_dir}/include/config/kernel.release
	local module_ver
	module_ver=$(<"${relfile}") || die

	local success=
	# not an actual loop but allows error handling with 'break'
	while :; do
		nonfatal mount-boot_check_status || break

		local image_path=$(dist-kernel_get_image_path)
		if use initramfs; then
			# putting it alongside kernel image as 'initrd' makes
			# kernel-install happier
			nonfatal dist-kernel_build_initramfs \
				"${kernel_dir}/${image_path%/*}/initrd" \
				"${module_ver}" || break
		fi

		nonfatal dist-kernel_install_kernel "${module_ver}" \
			"${kernel_dir}/${image_path}" \
			"${kernel_dir}/System.map" || break

		success=1
		break
	done

	if [[ ! ${success} ]]; then
		eerror
		eerror "The kernel files were copied to disk successfully but the kernel"
		eerror "was not deployed successfully.  Once you resolve the problems,"
		eerror "please run the equivalent of the following command to try again:"
		eerror
		eerror "    emerge --config ${CATEGORY}/${PN}:${SLOT}"
		die "Kernel install failed, please fix the problems and run emerge --config ${CATEGORY}/${PN}:${SLOT}"
	fi
}

# @FUNCTION: kernel-install_pkg_postinst
# @DESCRIPTION:
# Build an initramfs for the kernel, install it and update
# the /usr/src/linux symlink.
kernel-install_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	local dir_ver=${PV}${KV_LOCALVERSION}
	kernel-install_update_symlink "${EROOT}/usr/src/linux" "${dir_ver}"

	if [[ -z ${ROOT} ]]; then
		kernel-install_install_all "${dir_ver}"
	fi
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
# Clean up the generated initramfs from the removed kernel directory.
kernel-install_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${ROOT} ]] && use initramfs; then
		local dir_ver=${PV}${KV_LOCALVERSION}
		local kernel_dir=${EROOT}/usr/src/linux-${dir_ver}
		local image_path=$(dist-kernel_get_image_path)
		ebegin "Removing initramfs"
		rm -f "${kernel_dir}/${image_path%/*}"/initrd{,.uefi} &&
			find "${kernel_dir}" -depth -type d -empty -delete
		eend ${?}
	fi
}

# @FUNCTION: kernel-install_pkg_config
# @DESCRIPTION:
# Rebuild the initramfs and reinstall the kernel.
kernel-install_pkg_config() {
	[[ -z ${ROOT} ]] || die "ROOT!=/ not supported currently"

	kernel-install_install_all "${PV}${KV_LOCALVERSION}"
}

fi

EXPORT_FUNCTIONS src_test pkg_preinst pkg_postinst pkg_prerm pkg_postrm
EXPORT_FUNCTIONS pkg_config pkg_pretend
