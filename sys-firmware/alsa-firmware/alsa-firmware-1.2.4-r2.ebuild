# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alsa.asc
inherit linux-info udev verify-sig

DESCRIPTION="Advanced Linux Sound Architecture firmware"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="
	https://www.alsa-project.org/files/pub/firmware/${P}.tar.bz2
	verify-sig? ( https://www.alsa-project.org/files/pub/firmware/${P}.tar.bz2.sig )
"

LICENSE="
	GPL-2 freedist
	alsa_cards_korg1212? ( all-rights-reserved )
	alsa_cards_maestro3? ( all-rights-reserved )
	alsa_cards_sb16? ( all-rights-reserved )
	alsa_cards_wavefront? ( all-rights-reserved )
	alsa_cards_ymfpci? ( all-rights-reserved )
"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

ECHOAUDIO_CARDS="
	alsa_cards_darla20 alsa_cards_gina20 alsa_cards_layla20
	alsa_cards_darla24 alsa_cards_gina24 alsa_cards_layla24
	alsa_cards_mona alsa_cards_mia alsa_cards_indigo
	alsa_cards_indigoio alsa_cards_echo3g
"

EMU_CARDS="
	alsa_cards_emu1212 alsa_cards_emu1616 alsa_cards_emu1820
	alsa_cards_emu10k1
"

IUSE="compress-xz compress-zstd +deduplicate
	alsa_cards_cs46xx alsa_cards_pcxhr alsa_cards_vx222
	alsa_cards_usb-usx2y alsa_cards_hdsp alsa_cards_hdspm
	alsa_cards_mixart alsa_cards_asihpi alsa_cards_sb16
	alsa_cards_korg1212 alsa_cards_maestro3 alsa_cards_ymfpci
	alsa_cards_wavefront alsa_cards_msnd-pinnacle alsa_cards_aica
	alsa_cards_ca0132 ${ECHOAUDIO_CARDS} ${EMU_CARDS}
"
REQUIRED_USE="?? ( compress-xz compress-zstd )"

RESTRICT="
	alsa_cards_korg1212? ( bindist )
	alsa_cards_maestro3? ( bindist )
	alsa_cards_sb16? ( bindist )
	alsa_cards_wavefront? ( bindist )
	alsa_cards_ymfpci? ( bindist )
"

RDEPEND="
	alsa_cards_usb-usx2y? ( sys-apps/fxload )
	alsa_cards_hdsp? ( media-sound/alsa-tools )
	alsa_cards_hdspm? ( media-sound/alsa-tools )
	deduplicate? (
		alsa_cards_ca0132? ( sys-kernel/linux-firmware[redistributable] )
		alsa_cards_korg1212? ( sys-kernel/linux-firmware[unknown-license] )
		alsa_cards_maestro3? ( sys-kernel/linux-firmware[unknown-license] )
		alsa_cards_sb16? ( sys-kernel/linux-firmware[unknown-license] )
		alsa_cards_wavefront? ( sys-kernel/linux-firmware[unknown-license] )
		alsa_cards_ymfpci? ( sys-kernel/linux-firmware[unknown-license] )
	)
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-alsa )"

DOCS="README"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-musl.patch
)

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

src_configure() {
	local myeconfargs=(
		--with-hotplug-dir=/lib/firmware
		$(use_enable alsa_cards_usb-usx2y buildfw)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use alsa_cards_pcxhr; then
		rm -r "${ED}"/usr/share/alsa/firmware/pcxhrloader "${ED}"/lib/firmware/pcxhr || die
	fi

	if ! use alsa_cards_vx222; then
		rm -r "${ED}"/usr/share/alsa/firmware/vxloader || die
	fi

	if ! use alsa_cards_usb-usx2y; then
		rm -r "${ED}"/usr/share/alsa/firmware/usx2yloader || die
		if ! use alsa_cards_vx222; then
			rm -r "${ED}"/lib/firmware/vx || die
		fi
	else
		udev_dorules "${FILESDIR}"/52-usx2yaudio.rules
	fi

	if ! use alsa_cards_mixart; then
		rm -r "${ED}"/usr/share/alsa/firmware/mixartloader "${ED}"/lib/firmware/mixart || die
	fi

	if ! use alsa_cards_hdsp && ! use alsa_cards_hdspm; then
		rm -r "${ED}"/usr/share/alsa/firmware/hdsploader || die
		rm "${ED}"/lib/firmware/digiface_firmware{,_rev11}.bin || die
		rm "${ED}"/lib/firmware/multiface_firmware{,_rev11}.bin || die
		rm "${ED}"/lib/firmware/rpm_firmware.bin || die
	fi

	if ! use alsa_cards_asihpi; then
		rm -r "${ED}"/lib/firmware/asihpi || die
	fi

	if ! use alsa_cards_sb16; then
		rm -r "${ED}"/lib/firmware/sb16 || die
	elif use deduplicate; then
		rm -r "${ED}"/lib/firmware/sb16 || die
	fi

	if ! use alsa_cards_korg1212; then
		rm -r "${ED}"/lib/firmware/korg || die
	elif use deduplicate; then
		rm "${ED}"/lib/firmware/korg/k1212.dsp || die
	fi

	if ! use alsa_cards_maestro3; then
		rm -r "${ED}"/lib/firmware/ess || die
	elif use deduplicate; then
		rm "${ED}"/lib/firmware/ess/maestro3_assp_{kernel,minisrc}.fw || die
	fi

	if ! use alsa_cards_ymfpci && ! use alsa_cards_wavefront; then
		rm -r "${ED}"/lib/firmware/yamaha || die
	elif use deduplicate; then
		rm -r "${ED}"/lib/firmware/yamaha || die
	fi

	if ! use alsa_cards_msnd-pinnacle; then
		rm -r "${ED}"/lib/firmware/turtlebeach || die
	fi

	if ! use alsa_cards_aica; then
		rm "${ED}"/lib/firmware/aica_firmware.bin || die
	fi

	if ! use alsa_cards_ca0132; then
		rm "${ED}"/lib/firmware/ctspeq.bin || die
		rm "${ED}"/lib/firmware/ctefx{,-desktop,-r3di}.bin || die
	elif use deduplicate; then
		rm "${ED}"/lib/firmware/ctspeq.bin || die
		rm "${ED}"/lib/firmware/ctefx.bin || die
	fi

	if ! use alsa_cards_cs46xx; then
		rm -r "${ED}"/lib/firmware/cs46xx || die
	fi

	local ea=
	for card in ${ECHOAUDIO_CARDS}; do
		use ${card} && ea=1 && break
	done

	local emu=
	for card in ${EMU_CARDS}; do
		use ${card} && emu=1 && break
	done

	if [[ ! ${ea} ]]; then
		rm -r "${ED}"/lib/firmware/ea || die
	fi
	if [[ ! ${emu} ]]; then
		rm -r "${ED}"/lib/firmware/emu || die
	fi

	# Copied from sys-kernel/linux-firmware
	if use compress-xz; then
		find "${ED}"/lib/firmware -type f -exec \
			xz --compress --quiet --check=crc32 "{}" \; || die
	elif use compress-zstd; then
		find "${ED}"/lib/firmware -type f -exec \
			zstd --compress --quiet --rm "{}" \; || die
	fi
}

pkg_preinst() {
	if [[ ! -d "${ED}"/lib/firmware ]]; then
		ewarn "No firmware files are being installed, is ALSA_CARDS= empty?"
		ewarn "Please populate ALSA_CARDS with your sound card in make.conf"
	fi
}

pkg_postinst() {
	udev_reload
	if use alsa_cards_msnd-pinnacle; then
		einfo "Please download the actual firmware files from:"
		einfo "    ftp://ftp.voyetra.com/pub/tbs/msndcl/msndvkit.zip"
		einfo "    ftp://ftp.voyetra.com/pub/tbs/pinn/pnddk100.zip"
		einfo "and copy them to /etc/sound/. Registration required."
		einfo
		einfo "See also: https://www.kernel.org/doc/Documentation/sound/oss/MultiSound"
	fi
}
