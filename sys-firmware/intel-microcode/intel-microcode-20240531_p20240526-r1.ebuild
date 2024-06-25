# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dist-kernel-utils linux-info mount-boot

# Find updates by searching and clicking the first link (hopefully it's the one):
# https://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File
#
#
# Package Maintenance instructions:
# 1. The ebuild is in the form of intel-microcode-<INTEL_SNAPSHOT>_p<COLLECTION_SNAPSHOT>.ebuild
# 2. The INTEL_SNAPSHOT upstream is located at: https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files
# 3. The COLLECTION_SNAPSHOT is created manually using the following steps:
#   a. Clone the repository https://github.com/platomav/CPUMicrocodes
#   b. Rename the Intel directory to intel-microcode-collection-<YYYYMMDD>
#   c. From the CPUMicrocodes directory tar and xz compress the contents of intel-microcode-collection-<YYYYMMDD>:
#      tar -cJf intel-microcode-collection-<YYYYMMDD>.tar.xz intel-microcode-collection-<YYYYMMDD>/
#   d. This file can go in your devspace, add the URL to SRC_URI if it's not there
#      https://dev.gentoo.org/~<dev nick>/dist/intel-microcode/intel-microcode-collection-${COLLECTION_SNAPSHOT}.tar.xz
#
# PV:
# * the first date is upstream
# * the second date is snapshot (use last commit date in repo) from intel-microcode-collection

COLLECTION_SNAPSHOT="${PV##*_p}"
INTEL_SNAPSHOT="${PV/_p*}"
#NUM="28087"

#https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}
#https://downloadmirror.intel.com/${NUM}/eng/microcode-${INTEL_SNAPSHOT}.tgz

DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files https://github.com/platomav/CPUMicrocodes http://inertiawar.com/microcode/"
SRC_URI="
	https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/archive/microcode-${INTEL_SNAPSHOT}.tar.gz
	https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/raw/437f382b1be4412b9d03e2bbdcda46d83d581242/intel-ucode/06-4e-03 -> intel-ucode-sig_0x406e3-rev_0xd6.bin
	https://dev.gentoo.org/~mpagano/dist/intel-microcode/intel-microcode-collection-${COLLECTION_SNAPSHOT}.tar.xz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/intel-microcode-collection-${COLLECTION_SNAPSHOT}.tar.xz
"
S="${WORKDIR}"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="dist-kernel hostonly +initramfs +split-ucode vanilla"
REQUIRED_USE="!dist-kernel? ( || ( initramfs split-ucode ) )"
RESTRICT="binchecks strip"

BDEPEND=">=sys-apps/iucode_tool-2.3"
# !<sys-apps/microcode-ctl-1.17-r2 due to bug #268586
RDEPEND="
	dist-kernel? ( virtual/dist-kernel )
	hostonly? ( sys-apps/iucode_tool )
"
IDEPEND="
	dist-kernel? (
		initramfs? ( sys-kernel/installkernel )
	)
"

# Blacklist bad microcode here.
# 0x000406f1 aka 06-4f-01 aka CPUID 406F1 require newer microcode loader
MICROCODE_BLACKLIST_DEFAULT="-s !0x000406f1"

# https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/issues/31
MICROCODE_BLACKLIST_DEFAULT+=" -s !0x000406e3,0xc0,eq:0x00dc"

# https://bugs.gentoo.org/722768
MICROCODE_BLACKLIST_DEFAULT+=" -s !0x000406e3,0xc0,eq:0x00da"

# https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/commit/49bb67f32a2e3e631ba1a9a73da1c52e1cac7fd9
MICROCODE_BLACKLIST_DEFAULT+=" -s !0x000806c1,0x80,eq:0x0068"

# In case we want to set some defaults ...
MICROCODE_SIGNATURES_DEFAULT=""

# Advanced users only!
# Set MIRCOCODE_SIGNATURES to merge with:
# only current CPU: MICROCODE_SIGNATURES="-S"
# only specific CPU: MICROCODE_SIGNATURES="-s 0x00000f4a -s 0x00010676"
# exclude specific CPU: MICROCODE_SIGNATURES="-s !0x00000686"

pkg_pretend() {
	if use initramfs; then
		if [[ -z ${ROOT} ]] && use dist-kernel; then
			# Check, but don't die because we can fix the problem and then
			# emerge --config ... to re-run installation.
			nonfatal mount-boot_check_status
		else
			mount-boot_pkg_pretend
		fi
	fi
}

src_prepare() {
	default

	if cd Intel-Linux-Processor-Microcode-Data* &>/dev/null; then
		# new tarball format from GitHub
		mv * ../ || die "Failed to move Intel-Linux-Processor-Microcode-Data*"
		cd .. || die
		rm -r Intel-Linux-Processor-Microcode-Data* || die
	fi

	mkdir intel-ucode-old || die
	cp "${DISTDIR}"/intel-ucode-sig_0x406e3-rev_0xd6.bin "${S}"/intel-ucode-old/ || die

	# Prevent "invalid file format" errors from iucode_tool
	rm -f "${S}"/intel-ucod*/list || die

	# https://gitlab.com/iucode-tool/iucode-tool/-/issues/4
	rm "${S}"/intel-microcode-collection-${COLLECTION_SNAPSHOT}/cpu106C0_plat01_ver00000007_2007-08-24_PRD_923CDFA3.bin || die

	# Remove non-microcode file from list
	rm -f "${S}"/intel-microcode-collection-${COLLECTION_SNAPSHOT}/LICENSE || die
	rm -f "${S}"/intel-ucode*/LICENSE || die
}

src_install() {
	# This will take ALL of the upstream microcode sources:
	# - microcode.dat
	# - intel-ucode/
	# In some cases, they have not contained the same content (eg the directory has newer stuff).
	MICROCODE_SRC=(
		"${S}"/intel-ucode/
		"${S}"/intel-ucode-with-caveats/
		"${S}"/intel-ucode-old/
	)

	# Allow users who are scared about microcode updates not included in Intel's official
	# microcode tarball to opt-out and comply with Intel marketing
	if ! use vanilla; then
		MICROCODE_SRC+=( "${S}"/intel-microcode-collection-${COLLECTION_SNAPSHOT} )
	fi

	# These will carry into pkg_preinst via env saving.
	: ${MICROCODE_BLACKLIST=${MICROCODE_BLACKLIST_DEFAULT}}
	: ${MICROCODE_SIGNATURES=${MICROCODE_SIGNATUES_DEFAULT}}

	opts=(
		${MICROCODE_BLACKLIST}
		${MICROCODE_SIGNATURES}
		# be strict about what we are doing
		--overwrite
		--strict-checks
		--no-ignore-broken
		# we want to install latest version
		--no-downgrade
		# show everything we find
		--list-all
		# show what we selected
		--list
	)

	# Instruct Dracut on whether or not we want the microcode in initramfs
	# Use here 15 instead of 10, intel-microcode overwrites linux-firmware
	(
		insinto /usr/lib/dracut/dracut.conf.d
		newins - 15-${PN}.conf <<<"early_microcode=$(usex initramfs)"
	)
	if use initramfs; then
		# Install installkernel/kernel-install hooks for non-dracut initramfs
		# generators that don't bundled the microcode
		(
			exeinto /usr/lib/kernel/preinst.d
			doexe "${FILESDIR}/35-intel-microcode.install"
			exeinto /usr/lib/kernel/install.d
			doexe "${FILESDIR}/35-intel-microcode-systemd.install"
		)
	fi

	# The earlyfw cpio needs to be in /boot because it must be loaded before
	# rootfs is mounted.
	if ! use dist-kernel && use initramfs; then
		dodir /boot && opts+=( --write-earlyfw="${ED}/boot/intel-uc.img" )
	fi

	keepdir /lib/firmware/intel-ucode
	opts+=( --write-firmware="${ED}/lib/firmware/intel-ucode" )

	iucode_tool \
		"${opts[@]}" \
		"${MICROCODE_SRC[@]}" \
		|| die "iucode_tool ${opts[@]} ${MICROCODE_SRC[@]}"

	dodoc releasenote.md
}

pkg_preinst() {
	if [[ ${MICROCODE_BLACKLIST} != ${MICROCODE_BLACKLIST_DEFAULT} ]]; then
		ewarn "MICROCODE_BLACKLIST is set to \"${MICROCODE_BLACKLIST}\" instead of default \"${MICROCODE_BLACKLIST_DEFAULT}\". You are on your own!"
	fi

	if [[ ${MICROCODE_SIGNATURES} != ${MICROCODE_SIGNATURES_DEFAULT} ]]; then
		ewarn "Package was created using advanced options:"
		ewarn "MICROCODE_SIGNATURES is set to \"${MICROCODE_SIGNATURES}\" instead of default \"${MICROCODE_SIGNATURES_DEFAULT}\"!"
	fi

	# Make sure /boot is available if needed.
	use initramfs && ! use dist-kernel && mount-boot_pkg_preinst

	local _initramfs_file="${ED}/boot/intel-uc.img"

	if use hostonly; then
		# While this output looks redundant we do this check to detect
		# rare cases where iucode_tool was unable to detect system's processor(s).
		local _detected_processors=$(iucode_tool --scan-system 2>&1)
		if [[ -z "${_detected_processors}" ]]; then
			ewarn "Looks like iucode_tool was unable to detect any processor!"
		else
			einfo "Only installing ucode(s) for ${_detected_processors#iucode_tool: system has } due to USE=hostonly ..."
		fi

		opts=(
			--scan-system
			# be strict about what we are doing
			--overwrite
			--strict-checks
			--no-ignore-broken
			# we want to install latest version
			--no-downgrade
			# show everything we find
			--list-all
			# show what we selected
			--list
		)

		# The earlyfw cpio needs to be in /boot because it must be loaded before
		# rootfs is mounted.
		if ! use dist-kernel && use initramfs; then
			opts+=( --write-earlyfw=${_initramfs_file} )
		fi

		if use split-ucode; then
			opts+=( --write-firmware="${ED}/lib/firmware/intel-ucode" )
		fi

		opts+=( "${ED}/lib/firmware/intel-ucode-temp" )

		mv "${ED}"/lib/firmware/intel-ucode{,-temp} || die
		keepdir /lib/firmware/intel-ucode

		iucode_tool "${opts[@]}" || die "iucode_tool ${opts[@]}"

		rm -r "${ED}"/lib/firmware/intel-ucode-temp || die

	elif ! use split-ucode; then # hostonly disabled
		rm -r "${ED}"/lib/firmware/intel-ucode || die
	fi

	# Because it is possible that this package will install not one single file
	# due to user selection which is still somehow unexpected we add the following
	# check to inform user so that the user has at least a chance to detect
	# a problem/invalid select.
	local _has_installed_something=
	if use initramfs && [[ -s "${_initramfs_file}" ]]; then
		_has_installed_something="yes"
	elif use split-ucode; then
		_has_installed_something=$(find "${ED}/lib/firmware/intel-ucode" -maxdepth 0 -not -empty -exec echo yes \;)
	fi

	if use hostonly && [[ -n "${_has_installed_something}" ]]; then
		elog "You only installed ucode(s) for all currently available (=online)"
		elog "processor(s). Remember to re-emerge this package whenever you"
		elog "change the system's processor model."
		elog ""
	elif [[ -z "${_has_installed_something}" ]]; then
		ewarn "WARNING:"
		if [[ ${MICROCODE_SIGNATURES} != ${MICROCODE_SIGNATURES_DEFAULT} ]]; then
			ewarn "No ucode was installed! Because you have created this package"
			ewarn "using MICROCODE_SIGNATURES variable please double check if you"
			ewarn "have an invalid select."
			ewarn "It's rare but it is also possible that just no ucode update"
			ewarn "is available for your processor(s). In this case it is safe"
			ewarn "to ignore this warning."
		else
			ewarn "No ucode was installed! It's rare but it is also possible"
			ewarn "that just no ucode update is available for your processor(s)."
			ewarn "In this case it is safe to ignore this warning."
		fi

		ewarn ""

		if use hostonly; then
			ewarn "Unset \"hostonly\" USE flag to install all available ucodes."
			ewarn ""
		fi
	fi
}

pkg_prerm() {
	# Make sure /boot is mounted so that we can remove /boot/intel-uc.img!
	use initramfs && ! use dist-kernel && mount-boot_pkg_prerm
}

pkg_postrm() {
	# Don't forget to umount /boot if it was previously mounted by us.
	use initramfs && ! use dist-kernel && mount-boot_pkg_postrm
}

pkg_postinst() {
	if use initramfs; then
		if [[ -z ${ROOT} ]] && use dist-kernel; then
			dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
		else
			# Don't forget to umount /boot if it was previously mounted by us.
			mount-boot_pkg_postinst
		fi
	fi

	# We cannot give detailed information if user is affected or not:
	# If MICROCODE_BLACKLIST wasn't modified, user can still use MICROCODE_SIGNATURES
	# to to force a specific, otherwise blacklisted, microcode. So we
	# only show a generic warning based on running kernel version:
	if kernel_is -lt 4 14 34; then
		ewarn "${P} contains microcode updates which require"
		ewarn "additional kernel patches which aren't yet included in kernel <4.14.34."
		ewarn "Loading such a microcode through kernel interface from an unpatched kernel"
		ewarn "can crash your system!"
		ewarn ""
		ewarn "Those microcodes are blacklisted per default. However, if you have altered"
		ewarn "MICROCODE_BLACKLIST or MICROCODE_SIGNATURES, you maybe have unintentionally"
		ewarn "re-enabled those microcodes...!"
		ewarn ""
		ewarn "Check \"${EROOT}/usr/share/doc/${PN}-*/releasenot*\" if your microcode update"
		ewarn "requires additional kernel patches or not."
	fi
}
