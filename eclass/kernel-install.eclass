# Copyright 2020-2024 Gentoo Authors
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
# The eclass exports src_test, pkg_preinst, pkg_postinst and pkg_postrm.

# @ECLASS_VARIABLE: KERNEL_IUSE_GENERIC_UKI
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, adds IUSE=generic-uki and required
# logic to install a generic unified kernel image.

# @ECLASS_VARIABLE: KV_FULL
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the full kernel release version, e.g.
# '6.9.6-gentoo-dist'. Defaults to ${PV}${KV_LOCALVERSION},
# but can be set by the ebuild when this default value does
# not match the kernel release. kernel-build.eclass sets this
# to whatever is in the built kernel's kernel.release file.

# @ECLASS_VARIABLE: KV_LOCALVERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the kernel LOCALVERSION, e.g. '-gentoo'.
# Needs to be set only when installing binary kernels,
# kernel-build.eclass obtains it from kernel config.

# @ECLASS_VARIABLE: INITRD_PACKAGES
# @INTERNAL
# @DESCRIPTION:
# Used with KERNEL_IUSE_GENERIC_UKI. The eclass sets this to an array of
# packages to depend on for building the generic UKI and their licenses.
# Used in kernel-build.eclass.

if [[ ! ${_KERNEL_INSTALL_ECLASS} ]]; then
_KERNEL_INSTALL_ECLASS=1

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit dist-kernel-utils mount-boot-utils multiprocessing toolchain-funcs

SLOT="${PV}"
IUSE="+initramfs test"
RESTRICT+="
	!test? ( test )
	test? ( userpriv )
	arm? ( test )
"

_IDEPEND_BASE="
	!initramfs? (
		>=sys-kernel/installkernel-14
	)
	initramfs? (
		|| (
			>=sys-kernel/installkernel-14[dracut(-)]
			>=sys-kernel/installkernel-14[ugrd(-)]
		)
	)
"

LICENSE="GPL-2"
if [[ ${KERNEL_IUSE_GENERIC_UKI} ]]; then
	IUSE+=" generic-uki modules-compress"
	# https://github.com/AndrewAmmerlaan/dist-kernel-log-to-licenses
	# This script can help with generating the array below, keep in mind
	# that it is not a fully automatic solution, i.e. use flags will
	# still have to handled manually.
	declare -gA INITRD_PACKAGES=(
		["app-alternatives/awk"]="CC0-1.0"
		["app-alternatives/gzip"]="CC0-1.0"
		["app-alternatives/sh"]="CC0-1.0"
		["app-arch/bzip2"]="BZIP2"
		["app-arch/gzip"]="GPL-3+"
		["app-arch/lz4"]="BSD-2 GPL-2"
		["app-arch/xz-utils"]="public-domain LGPL-2.1+ GPL-2+"
		["app-arch/zstd"]="|| ( BSD GPL-2 )"
		["app-crypt/argon2"]="|| ( Apache-2.0 CC0-1.0 )"
		["app-crypt/gnupg[smartcard,tpm(-)]"]="GPL-3+"
		["app-crypt/p11-kit"]="MIT"
		["app-crypt/tpm2-tools"]="BSD"
		["app-crypt/tpm2-tss"]="BSD-2"
		["app-misc/ddcutil"]="GPL-2"
		["app-misc/jq"]="MIT CC-BY-3.0"
		["app-shells/bash"]="GPL-3+"
		["dev-db/sqlite"]="public-domain"
		["dev-libs/cyrus-sasl"]="BSD-with-attribution"
		["dev-libs/expat"]="MIT"
		["dev-libs/glib"]="LGPL-2.1+"
		["dev-libs/hidapi"]="|| ( BSD GPL-3 HIDAPI )"
		["dev-libs/icu"]="BSD"
		["dev-libs/json-c"]="MIT"
		["dev-libs/libaio"]="LGPL-2"
		["dev-libs/libassuan"]="GPL-3 LGPL-2.1"
		["dev-libs/libevent"]="BSD"
		["dev-libs/libffi"]="MIT"
		["dev-libs/libgcrypt"]="LGPL-2.1 MIT"
		["dev-libs/libgpg-error"]="GPL-2 LGPL-2.1"
		["dev-libs/libp11"]="LGPL-2.1"
		["dev-libs/libpcre2"]="BSD"
		["dev-libs/libtasn1"]="LGPL-2.1+"
		["dev-libs/libunistring"]="|| ( LGPL-3+ GPL-2+ ) || ( FDL-1.2 GPL-3+ )"
		["dev-libs/libusb"]="LGPL-2.1"
		["dev-libs/lzo"]="GPL-2+"
		["dev-libs/npth"]="LGPL-2.1+"
		["dev-libs/nss"]="|| ( MPL-2.0 GPL-2 LGPL-2.1 )"
		["dev-libs/oniguruma"]="BSD-2"
		["dev-libs/opensc"]="LGPL-2.1"
		["dev-libs/openssl"]="Apache-2.0"
		["dev-libs/userspace-rcu"]="LGPL-2.1"
		["media-libs/libmtp"]="LGPL-2.1"
		["media-libs/libv4l"]="LGPL-2.1+"
		["net-dns/c-ares"]="MIT ISC"
		["net-dns/libidn2"]="|| ( GPL-2+ LGPL-3+ ) GPL-3+ unicode"
		["net-fs/cifs-utils"]="GPL-3"
		["net-fs/nfs-utils"]="GPL-2"
		["net-fs/samba"]="GPL-3"
		["net-libs/libmnl"]="LGPL-2.1"
		["net-libs/libndp"]="LGPL-2.1+"
		["net-libs/libtirpc"]="BSD BSD-2 BSD-4 LGPL-2.1+"
		["net-libs/nghttp2"]="MIT"
		["net-misc/curl"]="BSD curl ISC"
		["net-misc/networkmanager[iwd]"]="GPL-2+ LGPL-2.1+"
		["net-nds/openldap"]="OPENLDAP GPL-2"
		["net-wireless/bluez"]="GPL-2+ LGPL-2.1+"
		["net-wireless/iwd"]="GPL-2"
		["sys-apps/acl"]="LGPL-2.1"
		["sys-apps/attr"]="LGPL-2.1"
		["sys-apps/baselayout"]="GPL-2"
		["sys-apps/coreutils"]="GPL-3+"
		["sys-apps/dbus"]="|| ( AFL-2.1 GPL-2 )"
		["sys-apps/fwupd"]="LGPL-2.1+"
		["sys-apps/gawk"]="GPL-3+"
		["sys-apps/hwdata"]="GPL-2+"
		["sys-apps/iproute2"]="GPL-2"
		["sys-apps/kbd"]="GPL-2"
		["sys-apps/keyutils"]="GPL-2 LGPL-2.1"
		["sys-apps/kmod"]="LGPL-2"
		["sys-apps/less"]="|| ( GPL-3 BSD-2 )"
		["sys-apps/nvme-cli"]="GPL-2 GPL-2+"
		["sys-apps/pcsc-lite"]="BSD ISC MIT GPL-3+ GPL-2"
		["sys-apps/rng-tools"]="GPL-2"
		["sys-apps/sed"]="GPL-3+"
		["sys-apps/shadow"]="BSD GPL-2"
		["sys-apps/systemd[boot(-),cryptsetup,pkcs11,policykit,tpm,ukify(-)]"]="GPL-2 LGPL-2.1 MIT public-domain"
		["sys-apps/util-linux"]="GPL-2 GPL-3 LGPL-2.1 BSD-4 MIT public-domain"
		["sys-auth/polkit"]="LGPL-2"
		["sys-block/nbd"]="GPL-2"
		["sys-devel/gcc"]="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
		["sys-fs/btrfs-progs"]="GPL-2"
		["sys-fs/cryptsetup"]="GPL-2+"
		["sys-fs/dmraid"]="GPL-2"
		["sys-fs/dosfstools"]="GPL-3"
		["sys-fs/e2fsprogs"]="GPL-2 BSD"
		["sys-fs/lvm2[lvm]"]="GPL-2"
		["sys-fs/mdadm"]="GPL-2"
		["sys-fs/multipath-tools"]="GPL-2"
		["sys-fs/xfsprogs"]="LGPL-2.1"
		["sys-kernel/dracut"]="GPL-2"
		["sys-kernel/linux-firmware[redistributable,-unknown-license]"]="GPL-2 GPL-2+ GPL-3 BSD MIT || ( MPL-1.1 GPL-2 ) linux-fw-redistributable BSD-2 BSD BSD-4 ISC MIT"
		["sys-libs/glibc"]="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
		["sys-libs/libapparmor"]="GPL-2 LGPL-2.1"
		["sys-libs/libcap"]="|| ( GPL-2 BSD )"
		["sys-libs/libcap-ng"]="LGPL-2.1"
		["sys-libs/libnvme"]="LGPL-2.1+"
		["sys-libs/libseccomp"]="LGPL-2.1"
		["sys-libs/libxcrypt"]="LGPL-2.1+ public-domain BSD BSD-2"
		["sys-libs/ncurses"]="MIT"
		["sys-libs/pam"]="|| ( BSD GPL-2 )"
		["sys-libs/readline"]="GPL-3+"
		["sys-libs/zlib"]="ZLIB"
		["sys-process/procps"]="GPL-2+ LGPL-2+ LGPL-2.1+"
		["amd64? ( sys-firmware/intel-microcode )"]="amd64? ( intel-ucode )"
		["x86? ( sys-firmware/intel-microcode )"]="x86? ( intel-ucode )"
	)
	LICENSE+="
		generic-uki? ( ${INITRD_PACKAGES[@]} )
	"

	RDEPEND+="
		sys-apps/kmod[lzma]
	"
	IDEPEND="
		generic-uki? (
			>=sys-kernel/installkernel-14[-dracut(-),-ugrd(-),-ukify(-)]
		)
		!generic-uki? (
			${_IDEPEND_BASE}
		)
	"
else
	IDEPEND="${_IDEPEND_BASE}"
fi
unset _IDEPEND_BASE

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
		sparc? ( app-emulation/qemu[qemu_softmmu_targets_sparc,qemu_softmmu_targets_sparc64] )
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
		arm|ppc|ppc64|riscv|sparc|sparc64)
			echo ${ARCH}
		;;
		arm64)
			echo aarch64
			;;
		loong)
			echo loongarch64
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
	# Initrd images with systemd require some os-release file
	cp "${BROOT}/etc/os-release" "${imageroot}/etc/os-release" || die

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
		dracut-systemd systemd systemd-initrd # gets stuck in boot loop
	)

	# NB: if you pass a path that does not exist or is not a regular
	# file/directory, dracut will silently ignore it and use the default
	# https://github.com/dracutdevs/dracut/issues/1136
	> "${T}"/empty-file || die
	mkdir -p "${T}"/empty-directory || die

	local compress="gzip"
	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]] && use generic-uki; then
		# Test with same compression method as the generic initrd
		compress="xz -9e --check=crc32"
	fi

	dracut \
		--conf "${T}"/empty-file \
		--confdir "${T}"/empty-directory \
		--no-hostonly \
		--kmoddir "${modules}" \
		--force-add "qemu" \
		--omit "${omit_mods[*]}" \
		--nostrip \
		--no-early-microcode \
		--compress="${compress}" \
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

	if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
		use modules-sign && qemu_extra_append+=" module.sig_enforce=1"
	fi

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

	# Check, but don't die because we can fix the problem and then
	# emerge --config ... to re-run installation.
	nonfatal mount-boot_check_status

	if ! has_version -d sys-kernel/linux-firmware; then
		ewarn "sys-kernel/linux-firmware not found installed on your system."
		ewarn "This package provides various firmware files that may be needed"
		ewarn "for your hardware to work.  If in doubt, it is recommended"
		ewarn "to pause or abort the build process and install it before"
		ewarn "resuming."
		elog
		elog "If you decide to install linux-firmware later, you can rebuild"
		elog "the initramfs via issuing a command equivalent to:"
		elog
		elog "    emerge --config ${CATEGORY}/${PN}:${SLOT}"
	fi

	if ! use initramfs && ! has_version "${CATEGORY}/${PN}[-initramfs]"; then
		ewarn
		ewarn "WARNING: The default distribution kernel configuration is designed"
		ewarn "to be used with an initramfs! Although possible, there is no guarantee"
		ewarn "that distribution kernels will boot without an initramfs."
		ewarn
		ewarn "You have disabled the initramfs USE flag, and as a result the package manager"
        ewarn "will not enforce the configuration of an initramfs generator in"
        ewarn "sys-kernel/installkernel."
        ewarn
		ewarn "If you wish to use a custom initramfs generator, then please ensure that" 
        ewarn "/sbin/installkernel is capable of calling it via a kernel installation hook,"
        ewarn "and is also configured to use it via /etc/kernel/install.conf."
        ewarn
        ewarn "If you wish to boot without an initramfs, then please ensure that"
        ewarn "all kernel drivers required to boot your system are built into the"
        ewarn "kernel by modifying the default distribution kernel configuration"
        ewarn "using /etc/kernel/config.d"
        ewarn
		ewarn "Please refer to the installkernel and distribution kernel documentation:"
		ewarn "    https://wiki.gentoo.org/wiki/Installkernel"
        ewarn "    https://wiki.gentoo.org/wiki/Project:Distribution_Kernel"
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

	# Set KV_FULL to ${PV}${KV_LOCALVERSION} if it hasn't
	# been set elsewhere for backward compatibility with existing
	# bin-kernel packages
	if [[ -z ${KV_FULL} ]]; then
		KV_FULL=${PV}${KV_LOCALVERSION}
	fi

	local kernel_dir=${ED}/usr/src/linux-${KV_FULL}
	local image_path=$(dist-kernel_get_image_path)
	[[ ! -d ${kernel_dir} ]] &&
		die "Kernel directory ${kernel_dir} not installed!"

	# perform the version check for release ebuilds only
	if [[ ${PV} != *9999 ]]; then
		local expected_ver=$(dist-kernel_PV_to_KV "${PV}")

		if [[ ${KV_FULL} != ${expected_ver}* ]]; then
			eerror "Kernel version does not match PV!"
			eerror "Source version: ${KV_FULL}"
			eerror "Expected (PV*): ${expected_ver}*"
			eerror "Please ensure you are applying the correct patchset."
			die "Kernel version mismatch: got ${KV_FULL}, expected ${expected_ver}*"
		fi
	fi

	if [[ -L ${EROOT}/lib && ${EROOT}/lib -ef ${EROOT}/usr/lib ]]; then
		# Adjust symlinks for merged-usr.
		rm "${ED}/lib/modules/${KV_FULL}"/{build,source} || die
		dosym "../../../src/linux-${KV_FULL}" "/usr/lib/modules/${KV_FULL}/build"
		dosym "../../../src/linux-${KV_FULL}" "/usr/lib/modules/${KV_FULL}/source"
		local file
		for file in .config System.map; do
			if [[ -L "${ED}/lib/modules/${KV_FULL}/${file#.}" ]]; then
				rm "${ED}/lib/modules/${KV_FULL}/${file#.}" || die
				dosym "../../../src/linux-${KV_FULL}/${file}" "/usr/lib/modules/${KV_FULL}/${file#.}"
			fi
		done
		for file in vmlinux vmlinuz; do
			if [[ -L "${ED}/lib/modules/${KV_FULL}/${file}" ]]; then
				rm "${ED}/lib/modules/${KV_FULL}/${file}" || die
				dosym "../../../src/linux-${KV_FULL}/${image_path}" "/usr/lib/modules/${KV_FULL}/${file}"
			fi
		done
	fi
}

# @FUNCTION: kernel-install_extract_from_uki
# @USAGE: <type> <input> <output>
# @DESCRIPTION:
# Extracts kernel image or initrd from an UKI.  <type> must be "linux"
# or "initrd".
kernel-install_extract_from_uki() {
	[[ ${#} -eq 3 ]] || die "${FUNCNAME}: invalid arguments"
	local extract_type=${1}
	local uki=${2}
	local out=${3}

	$(tc-getOBJCOPY) -O binary "-j.${extract_type}" "${uki}" "${out}" ||
		die "Failed to extract ${extract_type}"
	chmod 644 "${out}" || die
}

# @FUNCTION: kernel-install_install_all
# @USAGE: <ver>
# @DESCRIPTION:
# Install the kernel, initramfs/uki generation is optionally handled by
# installkernel. This is called from pkg_postinst() and pkg_config().
# <ver> is the full kernel version.
kernel-install_install_all() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: invalid arguments"
	local dir_ver=${1}
	local kernel_dir=${EROOT}/usr/src/linux-${dir_ver}
	local relfile=${kernel_dir}/include/config/kernel.release
	local image_path=$(dist-kernel_get_image_path)
	local image_dir=${image_path%/*}
	local module_ver
	module_ver=$(<"${relfile}") || die

	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]]; then
		if use generic-uki; then
			# Populate placeholders
			kernel-install_extract_from_uki linux \
				"${kernel_dir}/${image_dir}"/uki.efi \
				"${kernel_dir}/${image_path}"
			kernel-install_extract_from_uki initrd \
				"${kernel_dir}/${image_dir}"/uki.efi \
				"${kernel_dir}/${image_dir}"/initrd
			if [[ -L ${EROOT}/lib && ${EROOT}/lib -ef ${EROOT}/usr/lib ]]; then
				ln -sf "../../../src/linux-${dir_ver}/${image_dir}/initrd" "${EROOT}/usr/lib/modules/${module_ver}/initrd" || die
				ln -sf "../../../src/linux-${dir_ver}/${image_dir}/uki.efi" "${EROOT}/usr/lib/modules/${module_ver}/uki.efi" || die
			else
				ln -sf "../../../usr/src/linux-${dir_ver}/${image_dir}/initrd" "${EROOT}/lib/modules/${module_ver}/initrd" || die
				ln -sf "../../../usr/src/linux-${dir_ver}/${image_dir}/uki.efi" "${EROOT}/lib/modules/${module_ver}/uki.efi" || die
			fi
		else
			# Remove placeholders, -f because these have already been removed
			# when doing emerge --config.
			rm -f "${kernel_dir}/${image_dir}"/{initrd,uki.efi} || die
		fi
	fi

	dist-kernel_install_kernel "${module_ver}" "${kernel_dir}/${image_path}" \
		"${kernel_dir}/System.map"
}

# @FUNCTION: kernel-install_pkg_postinst
# @DESCRIPTION:
# Build an initramfs for the kernel, install it and update
# the /usr/src/linux symlink.
kernel-install_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	kernel-install_update_symlink "${EROOT}/usr/src/linux" "${KV_FULL}"
	dist-kernel_compressed_module_cleanup \
		"${EROOT}/lib/modules/${KV_FULL}"

	if [[ -z ${ROOT} ]]; then
		kernel-install_install_all "${KV_FULL}"
	fi

	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]] && use generic-uki; then
		ewarn "The prebuilt initramfs and unified kernel image are highly experimental!"
		ewarn "These images may not work on your system. Please ensure that a working"
		ewarn "alternative kernel(+initramfs) or UKI is also installed before rebooting!"
		ewarn
		ewarn "Note that when secureboot is enabled in the firmware settings any kernel"
		ewarn "command line arguments supplied to the UKI by the bootloader are ignored."
		ewarn "To ensure the root partition can be found, systemd-gpt-auto-generator must"
		ewarn "be used. See [1] for more information."
		ewarn
		ewarn "[1]: https://wiki.gentoo.org/wiki/Systemd#Automatic_mounting_of_partitions_at_boot"
	fi
}

# @FUNCTION: kernel-install_pkg_postrm
# @DESCRIPTION:
# Clean up the generated initramfs from the removed kernel directory.
kernel-install_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${ROOT} && ! ${KERNEL_IUSE_GENERIC_UKI} ]]; then
		local kernel_dir=${EROOT}/usr/src/linux-${KV_FULL}
		local image_path=$(dist-kernel_get_image_path)
		ebegin "Removing initramfs"
		rm -f "${kernel_dir}/${image_path%/*}"/{initrd,uki.efi} &&
			find "${kernel_dir}" -depth -type d -empty -delete
		eend ${?}
	fi
}

# @FUNCTION: kernel-install_pkg_config
# @DESCRIPTION:
# Rebuild the initramfs and reinstall the kernel.
kernel-install_pkg_config() {
	[[ -z ${ROOT} ]] || die "ROOT!=/ not supported currently"

	if [[ -z ${KV_FULL} ]]; then
		KV_FULL=${PV}${KV_LOCALVERSION}
	fi

	kernel-install_install_all "${KV_FULL}"
}

# @FUNCTION: kernel-install_compress_modules
# @DESCRIPTION:
# Compress modules installed in ED, if USE=modules-compress is enabled.
kernel-install_compress_modules() {
	debug-print-function ${FUNCNAME} "${@}"

	if use modules-compress; then
		einfo "Compressing kernel modules ..."
		if [[ -z ${KV_FULL} ]]; then
			KV_FULL=${PV}${KV_LOCALVERSION}
		fi
		local suffix=$(dist-kernel_get_module_suffix "${ED}/usr/src/linux-${KV_FULL}")
		local compress=()
		# Options taken from linux-mod-r1.eclass.
		# We don't instruct the compressor to parallelize because it applies
		# multithreading per file, so it works only for big files, and we have
		# lots of small files instead.
		case ${suffix} in
			.ko)
				return
				;;
			.ko.gz)
				compress+=( gzip )
				;;
			.ko.xz)
				compress+=( xz --check=crc32 --lzma2=dict=1MiB )
				;;
			.ko.zst)
				compress+=( zstd -q --rm )
				;;
			*)
				die "Unknown compressor: ${suffix}"
				;;
		esac

		find "${ED}/lib/modules/${KV_FULL}" -name '*.ko' -print0 |
			xargs -0 -P "$(makeopts_jobs)" -n 128 "${compress[@]}"
		assert "Compressing kernel modules failed"
	fi
}

fi

EXPORT_FUNCTIONS src_test pkg_preinst pkg_postinst pkg_postrm
EXPORT_FUNCTIONS pkg_config pkg_pretend
