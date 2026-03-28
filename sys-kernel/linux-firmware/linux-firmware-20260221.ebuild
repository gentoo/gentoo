# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dist-kernel-utils eapi9-ver linux-info mount-boot savedconfig

# In case this is a real snapshot, fill in commit below.
# For normal, tagged releases, leave blank
MY_COMMIT=""

if [[ ${PV} == 99999999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/${PN}.git"
else
	if [[ -n "${MY_COMMIT}" ]]; then
		SRC_URI="https://gitlab.com/kernel-firmware/linux-firmware/-/archive/${MY_COMMIT}/linux-firmware-${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2"
		S="${WORKDIR}/${PN}-${MY_COMMIT}"
	else
		SRC_URI="https://mirrors.edge.kernel.org/pub/linux/kernel/firmware/${P}.tar.xz"
	fi

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="Linux firmware files"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git"

LICENSE="GPL-2 GPL-2+ GPL-3 BSD MIT || ( MPL-1.1 GPL-2 )
	redistributable? ( linux-fw-redistributable BSD-2 BSD BSD-4 ISC MIT )
	unknown-license? ( all-rights-reserved )"
SLOT="0"
IUSE="bindist compress-xz compress-zstd deduplicate dist-kernel +initramfs +redistributable unknown-license"
REQUIRED_USE="initramfs? ( redistributable )
	?? ( compress-xz compress-zstd )
	savedconfig? ( !deduplicate )"

RESTRICT="binchecks strip test
	!bindist? ( bindist )
	unknown-license? ( bindist )"

BDEPEND="initramfs? ( app-alternatives/cpio )
	compress-xz? ( app-arch/xz-utils )
	compress-zstd? ( app-arch/zstd )
	deduplicate? ( app-misc/rdfind )
	${PYTHON_DEPS}"

#add anything else that collides to this
RDEPEND="!savedconfig? (
		redistributable? (
			!sys-firmware/alsa-firmware[alsa_cards_ca0132,-deduplicate(-)]
			!sys-block/qla-fc-firmware
			!sys-firmware/raspberrypi-wifi-ucode
		)
		unknown-license? (
			!sys-firmware/alsa-firmware[alsa_cards_korg1212,-deduplicate(-)]
			!sys-firmware/alsa-firmware[alsa_cards_maestro3,-deduplicate(-)]
			!sys-firmware/alsa-firmware[alsa_cards_sb16,-deduplicate(-)]
			!sys-firmware/alsa-firmware[alsa_cards_ymfpci,-deduplicate(-)]
		)
	)
	dist-kernel? (
		virtual/dist-kernel
		initramfs? (
			app-alternatives/cpio
		)
	)
"
IDEPEND="
	dist-kernel? (
		initramfs? ( sys-kernel/installkernel )
	)
"

QA_PREBUILT="*"
PATCHES=(
	"${FILESDIR}"/${PN}-copy-firmware-r9.patch
)

pkg_pretend() {
	if use initramfs; then
		if use dist-kernel; then
			# Check, but don't die because we can fix the problem and then
			# emerge --config ... to re-run installation.
			nonfatal mount-boot_check_status
		else
			mount-boot_pkg_pretend
		fi
	fi
}

pkg_setup() {
	if use compress-xz || use compress-zstd ; then
		local CONFIG_CHECK

		if kernel_is -ge 5 19; then
			use compress-xz && CONFIG_CHECK="~FW_LOADER_COMPRESS_XZ"
			use compress-zstd && CONFIG_CHECK="~FW_LOADER_COMPRESS_ZSTD"
		else
			use compress-xz && CONFIG_CHECK="~FW_LOADER_COMPRESS"
			if use compress-zstd; then
				eerror "Kernels <5.19 do not support ZSTD-compressed firmware files"
			fi
		fi
	fi
	linux-info_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 99999999* ]]; then
		git-r3_src_unpack
	else
		default
		# rename directory from git snapshot tarball
		if [[ ${#GIT_COMMIT} -gt 8 ]]; then
			mv ${PN}-*/ ${P} || die
		fi
	fi
}

src_prepare() {
	default

	# Stub out this script to avoid errors in the live ebuild
	cat >check_whence.py<<-EOF
	#!/bin/sh
	exit 0
	EOF

	cp "${FILESDIR}/${PN}-make-amd-ucode-img.bash" "${T}/make-amd-ucode-img" || die
	chmod +x "${T}/make-amd-ucode-img" || die

	if use initramfs && ! use dist-kernel; then
		if [[ -d "${S}/amd-ucode" ]]; then
			"${T}/make-amd-ucode-img" "${S}" "${S}/amd-ucode" || die
		else
			# If this will ever happen something has changed which
			# must be reviewed
			die "'${S}/amd-ucode' not found!"
		fi
	fi

	# whitelist of misc files
	local misc_files=(
		build_packages.py
		carl9170fw/autogen.sh
		carl9170fw/genapi.sh
		contrib/process_linux_firmware.py
		copy-firmware.sh
		check_whence.py
		dedup-firmware.sh
		LICEN[CS]E.*
		README.md
		WHENCE
	)

	# whitelist of images with a free software license
	local free_software=(
		# keyspan_pda (GPL-2+)
		keyspan_pda/keyspan_pda.fw
		keyspan_pda/xircom_pgs.fw
		# dsp56k (GPL-2+)
		dsp56k/bootstrap.bin
		# ath9k_htc (BSD GPL-2+ MIT)
		ath9k_htc/htc_7010-1.4.0.fw
		ath9k_htc/htc_9271-1.4.0.fw
		# pcnet_cs, 3c589_cs, 3c574_cs, serial_cs (dual GPL-2/MPL-1.1)
		cis/LA-PCM.cis
		cis/PCMLM28.cis
		cis/DP83903.cis
		cis/NE2K.cis
		cis/tamarack.cis
		cis/PE-200.cis
		cis/PE520.cis
		cis/3CXEM556.cis
		cis/3CCFEM556.cis
		cis/MT5634ZLX.cis
		cis/RS-COM-2P.cis
		cis/COMpad2.cis
		cis/COMpad4.cis
		# serial_cs (GPL-3)
		cis/SW_555_SER.cis
		cis/SW_7xx_SER.cis
		cis/SW_8xx_SER.cis
		# dvb-ttpci (GPL-2+)
		av7110/bootcode.bin
		# usbdux, usbduxfast, usbduxsigma (GPL-2+)
		usbdux_firmware.bin
		usbduxfast_firmware.bin
		usbduxsigma_firmware.bin
		# brcmfmac (GPL-2+)
		brcm/brcmfmac4330-sdio.Prowise-PT301.txt
		brcm/brcmfmac43340-sdio.meegopad-t08.txt
		brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt
		brcm/brcmfmac43362-sdio.lemaker,bananapro.txt
		brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt
		"brcm/brcmfmac43430a0-sdio.ONDA-V80 PLUS.txt"
		brcm/brcmfmac43430-sdio.AP6212.txt
		brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt
		brcm/brcmfmac43430-sdio.MUR1DX.txt
		brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt
		brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt
		brcm/brcmfmac4356-pcie.gpd-win-pocket.txt
		# isci (GPL-2)
		isci/isci_firmware.bin
		# carl9170 (GPL-2+)
		carl9170-1.fw
		# atusb (GPL-2+)
		atusb/atusb-0.2.dfu
		atusb/atusb-0.3.dfu
		atusb/rzusb-0.3.bin
		# mlxsw_spectrum (dual BSD/GPL-2)
		mellanox/mlxsw_spectrum-13.1420.122.mfa2
		mellanox/mlxsw_spectrum-13.1530.152.mfa2
		mellanox/mlxsw_spectrum-13.1620.192.mfa2
		mellanox/mlxsw_spectrum-13.1702.6.mfa2
		mellanox/mlxsw_spectrum-13.1703.4.mfa2
		mellanox/mlxsw_spectrum-13.1910.622.mfa2
		mellanox/mlxsw_spectrum-13.2000.1122.mfa2
	)

	# blacklist of images with unknown license
	local unknown_license=(
		korg/k1212.dsp
		ess/maestro3_assp_kernel.fw
		ess/maestro3_assp_minisrc.fw
		yamaha/ds1_ctrl.fw
		yamaha/ds1_dsp.fw
		yamaha/ds1e_ctrl.fw
		ttusb-budget/dspbootcode.bin
		emi62/bitstream.fw
		emi62/loader.fw
		emi62/midi.fw
		emi62/spdif.fw
		ti_3410.fw
		ti_5052.fw
		mts_mt9234mu.fw
		mts_mt9234zba.fw
		whiteheat.fw
		whiteheat_loader.fw
		cpia2/stv0672_vp4.bin
		vicam/firmware.fw
		edgeport/boot.fw
		edgeport/boot2.fw
		edgeport/down.fw
		edgeport/down2.fw
		edgeport/down3.bin
		sb16/mulaw_main.csp
		sb16/alaw_main.csp
		sb16/ima_adpcm_init.csp
		sb16/ima_adpcm_playback.csp
		sb16/ima_adpcm_capture.csp
		sun/cassini.bin
		acenic/tg1.bin
		acenic/tg2.bin
		adaptec/starfire_rx.bin
		adaptec/starfire_tx.bin
		yam/1200.bin
		yam/9600.bin
		ositech/Xilinx7OD.bin
		qlogic/isp1000.bin
		myricom/lanai.bin
		yamaha/yss225_registers.bin
		lgs8g75.fw
	)

	if use !unknown-license; then
		einfo "Removing files with unknown license ..."
		rm -v "${unknown_license[@]}" || die
	fi

	if use !redistributable; then
		# remove files _not_ in the free_software or unknown_license lists
		# everything else is confirmed (or assumed) to be redistributable
		# based on upstream acceptance policy
		einfo "Removing non-redistributable files ..."
		local OLDIFS="${IFS}"
		local IFS=$'\n'
		set -o pipefail
		find ! -type d -printf "%P\n" \
			| grep -Fvx -e "${misc_files[*]}" -e "${free_software[*]}" -e "${unknown_license[*]}" \
			| xargs -d '\n' --no-run-if-empty rm -v

		[[ ${?} -ne 0 ]] && die "Failed to remove non-redistributable files"

		IFS="${OLDIFS}"
	fi

	restore_config ${PN}.conf
}

src_install() {
	local FW_OPTIONS=( "-v" "-j1" )
	local files_to_keep=

	if use savedconfig; then
		if [[ -s "${S}/${PN}.conf" ]]; then
			files_to_keep="${T}/files_to_keep.lst"
			grep -v '^#' "${S}/${PN}.conf" 2>/dev/null > "${files_to_keep}" || die
			[[ -s "${files_to_keep}" ]] || die "grep failed, empty config file?"
			FW_OPTIONS+=( "--firmware-list" "${files_to_keep}" )
		fi
	fi

	if use compress-xz; then
		FW_OPTIONS+=( "--xz" )
	elif use compress-zstd; then
		FW_OPTIONS+=( "--zstd" )
	fi
	FW_OPTIONS+=( "${ED}/lib/firmware" )
	./copy-firmware.sh "${FW_OPTIONS[@]}" || die
	use deduplicate && { ./dedup-firmware.sh "${ED}/lib/firmware" || die; }

	pushd "${ED}/lib/firmware" &>/dev/null || die

	# especially use !redistributable will cause some broken symlinks
	einfo "Removing broken symlinks ..."
	find * -xtype l -print -delete || die

	# remove empty files and directories, bug #396073
	# Copy-firmware.sh may have made empty copies of files we removed
	find -empty -delete || die

	# sanity check
	if ! ( shopt -s failglob; : * ) 2>/dev/null; then
		eerror "No files to install. Check your USE flag settings"
		eerror "and the list of files in your saved configuration."
		die "Refusing to install an empty package"
	fi

	# create config file
	echo "# Remove files that shall not be installed from this list." > "${S}"/${PN}.conf || die
	find * ! -type d >> "${S}"/${PN}.conf || die
	save_config "${S}"/${PN}.conf

	popd &>/dev/null || die

	# Instruct Dracut on whether or not we want the microcode in initramfs
	(
		insinto /usr/lib/dracut/dracut.conf.d
		newins - 10-${PN}.conf <<<"early_microcode=$(usex initramfs)"
	)
	if use initramfs; then
		# Install installkernel/kernel-install hooks for non-dracut initramfs
		# generators that don't bundled the microcode
		dobin "${T}/make-amd-ucode-img"
		(
			exeinto /usr/lib/kernel/preinst.d
			doexe "${FILESDIR}/35-amd-microcode.install"
			exeinto /usr/lib/kernel/install.d
			doexe "${FILESDIR}/35-amd-microcode-systemd.install"
		)
	fi

	if use initramfs && ! use dist-kernel; then
		insinto /boot
		doins "${S}"/amd-uc.img
	fi

	dodoc README.md
	# some licenses require copyright and permission notice to be included
	use bindist && dodoc WHENCE LICEN[CS]E.*
}

pkg_preinst() {
	if use savedconfig; then
		ewarn "USE=savedconfig is active. You must handle file collisions manually."
	fi

	# Fix 'symlink is blocked by a directory' Bug #871315
	if has_version "<${CATEGORY}/${PN}-20220913-r2" ; then
		rm -rf "${EROOT}"/lib/firmware/qcom/LENOVO/21BX
	fi

	# Fix 'symlink is blocked by a directory' https://bugs.gentoo.org/958268#c3
	if has_version "<${CATEGORY}/${PN}-20250613" ; then
		rm -rf "${EROOT}"/lib/firmware/nvidia/{ad103,ad104,ad106,ad107}
	fi

	# Make sure /boot is available if needed.
	use initramfs && ! use dist-kernel && mount-boot_pkg_preinst
}

pkg_postinst() {
	elog "If you are only interested in particular firmware files, edit the saved"
	elog "configfile and remove those that you do not want."

	if ver_replacing -lt 20190514; then
		elog
		elog 'Starting with version 20190514, installation of many firmware'
		elog 'files is controlled by USE flags. Please review your USE flag'
		elog 'and package.license settings if you are missing some files.'
	fi

	if use initramfs; then
		if use dist-kernel; then
			dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}" --all
		else
			# Don't forget to umount /boot if it was previously mounted by us.
			mount-boot_pkg_postinst
		fi
	fi
}

pkg_prerm() {
	# Make sure /boot is mounted so that we can remove /boot/amd-uc.img!
	use initramfs && ! use dist-kernel && mount-boot_pkg_prerm
}

pkg_postrm() {
	# Don't forget to umount /boot if it was previously mounted by us.
	use initramfs && ! use dist-kernel && mount-boot_pkg_postrm
}
