# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit linux-info toolchain-funcs mount-boot

# Find updates by searching and clicking the first link (hopefully it's the one):
# https://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

COLLECTION_SNAPSHOT="${PV##*_p}"
INTEL_SNAPSHOT="${PV/_p*}"
NUM="28087"
DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="https://downloadmirror.intel.com/${NUM}/eng/microcode-${INTEL_SNAPSHOT}.tgz
	https://dev.gentoo.org/~whissi/dist/intel-microcode/intel-microcode-collection-${COLLECTION_SNAPSHOT}.tar.xz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="hostonly initramfs +split-ucode vanilla"
REQUIRED_USE="|| ( initramfs split-ucode )"

DEPEND="sys-apps/iucode_tool"

# !<sys-apps/microcode-ctl-1.17-r2 due to bug #268586
RDEPEND="hostonly? ( sys-apps/iucode_tool )"

RESTRICT="binchecks bindist mirror strip"

S=${WORKDIR}

# Blacklist bad microcode here.
# 0x000406f1 aka 06-4f-01 aka CPUID 406F1 require newer microcode loader
MICROCODE_BLACKLIST_DEFAULT="-s !0x000406f1"
MICROCODE_BLACKLIST="${MICROCODE_BLACKLIST:=${MICROCODE_BLACKLIST_DEFAULT}}"

# In case we want to set some defaults ...
MICROCODE_SIGNATURES_DEFAULT=""

# Advanced users only:
# merge with:
# only current CPU: MICROCODE_SIGNATURES="-S"
# only specific CPU: MICROCODE_SIGNATURES="-s 0x00000f4a -s 0x00010676"
# exclude specific CPU: MICROCODE_SIGNATURES="-s !0x00000686"
MICROCODE_SIGNATURES="${MICROCODE_SIGNATURES:=${MICROCODE_SIGNATURES_DEFAULT}}"

pkg_pretend() {
	use initramfs && mount-boot_pkg_pretend
}

src_prepare() {
	default

	# Prevent "invalid file format" errors from iucode_tool
	rm -f "${S}"/intel-ucod*/list || die
}

src_install() {
	# This will take ALL of the upstream microcode sources:
	# - microcode.dat
	# - intel-ucode/
	# In some cases, they have not contained the same content (eg the directory has newer stuff).
	MICROCODE_SRC=(
		"${S}"/intel-ucode/
		"${S}"/intel-ucode-with-caveats/
	)

	# Allow users who are scared about microcode updates not included in Intel's official
	# microcode tarball to opt-out and comply with Intel marketing
	if ! use vanilla; then
		MICROCODE_SRC+=( "${S}"/intel-microcode-collection-${COLLECTION_SNAPSHOT} )
	fi

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

	# The earlyfw cpio needs to be in /boot because it must be loaded before
	# rootfs is mounted.
	use initramfs && dodir /boot && opts+=( --write-earlyfw="${ED%/}"/boot/intel-uc.img )
	# split location (we use a temporary location so that we are able
	# to re-run iucode_tool in pkg_preinst; use keepdir instead of dodir to carry
	# this folder to pkg_preinst to avoid an error even if no microcode was selected):
	keepdir /tmp/intel-ucode && opts+=( --write-firmware="${ED%/}"/tmp/intel-ucode )

	iucode_tool \
		"${opts[@]}" \
		"${MICROCODE_SRC[@]}" \
		|| die "iucode_tool ${opts[@]} ${MICROCODE_SRC[@]}"

	dodoc releasenote

	# Record how package was created so we can show this in build.log
	# even for binary packages.
	if [[ "${MICROCODE_BLACKLIST}" != "${MICROCODE_BLACKLIST_DEFAULT}" ]]; then
		echo ${MICROCODE_BLACKLIST} > "${ED%/}/tmp/.blacklist_altered" || die "Failed to add marker that MICROCODE_BLACKLIST variable was used"
	fi

	if [[ "${MICROCODE_SIGNATURES}" != "${MICROCODE_SIGNATURES_DEFAULT}" ]]; then
		echo ${MICROCODE_SIGNATURES} > "${ED%/}/tmp/.signatures_altered" || die "Failed to add marker that MICROCODE_SIGNATURES variable was used"
	fi
}

pkg_preinst() {
	if [[ -f "${ED%/}/tmp/.blacklist_altered" ]]; then
		local _recorded_MICROCODE_BLACKLIST_value=$(cat "${ED%/}/tmp/.blacklist_altered")
		ewarn "MICROCODE_BLACKLIST is set to \"${_recorded_MICROCODE_BLACKLIST_value}\" instead of default \"${MICROCODE_BLACKLIST_DEFAULT}\". You are on your own!"
	fi

	if [[ -f "${ED%/}/tmp/.signatures_altered" ]]; then
		local _recorded_MICROCODE_SIGNATURES_value=$(cat "${ED%/}/tmp/.signatures_altered")
		ewarn "Package was created using advanced options:"
		ewarn "MICROCODE_SIGNATURES is set to \"${_recorded_MICROCODE_SIGNATURES_value}\" instead of default \"${MICROCODE_SIGNATURES_DEFAULT}\"!"
	fi

	# Make sure /boot is available if needed.
	use initramfs && mount-boot_pkg_preinst

	local _initramfs_file="${ED%/}/boot/intel-uc.img"
	local _ucode_dir="${ED%/}/lib/firmware/intel-ucode"

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
		use initramfs && opts+=( --write-earlyfw=${_initramfs_file} )
		# split location:
		use split-ucode && dodir /lib/firmware/intel-ucode && opts+=( --write-firmware=${_ucode_dir} )

		iucode_tool \
			"${opts[@]}" \
			"${ED%/}"/tmp/intel-ucode \
			|| die "iucode_tool ${opts[@]} ${ED%/}/tmp/intel-ucode"

	else
		if use split-ucode; then
			# Temporary /tmp/intel-ucode will become final /lib/firmware/intel-ucode ...
			dodir /lib/firmware
			mv "${ED%/}/tmp/intel-ucode" "${ED%/}/lib/firmware" || die "Failed to install splitted ucodes!"
		fi
	fi

	# Because it is possible that this package will install not one single file
	# due to user selection which is still somehow unexpected we add the following
	# check to inform user so that the user has at least a chance to detect
	# a problem/invalid select.
	local _has_installed_something=
	if use initramfs && [[ -s "${_initramfs_file}" ]]; then
		_has_installed_something="yes"
	elif use split-ucode; then
		_has_installed_something=$(find "${_ucode_dir}" -maxdepth 0 -not -empty -exec echo yes \;)
	fi

	if use hostonly && [[ -n "${_has_installed_something}" ]]; then
		elog "You only installed ucode(s) for all currently available (=online)"
		elog "processor(s). Remember to re-emerge this package whenever you"
		elog "change the system's processor model."
		elog ""
	elif [[ -z "${_has_installed_something}" ]]; then
		ewarn "WARNING:"
		if [[ -f "${ED%/}/tmp/.signatures_altered" ]]; then
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

	# Cleanup any temporary leftovers so that we don't merge any
	# unneeded files on disk.
	rm -r "${ED%/}/tmp" || die "Failed to cleanup '${ED%/}/tmp'"
}

pkg_prerm() {
	# Make sure /boot is mounted so that we can remove /boot/intel-uc.img!
	use initramfs && mount-boot_pkg_prerm
}

pkg_postrm() {
	# Don't forget to umount /boot if it was previously mounted by us.
	use initramfs && mount-boot_pkg_postrm
}

pkg_postinst() {
	# Don't forget to umount /boot if it was previously mounted by us.
	use initramfs && mount-boot_pkg_postinst

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
		ewarn "Check \"${EROOT%/}/usr/share/doc/${PN}-*/releasenot*\" if your microcode update"
		ewarn "requires additional kernel patches or not."
	fi
}
