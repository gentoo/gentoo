# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo linux-info optfeature

DESCRIPTION="Firmware and configuration instructions for Alcatel SpeedTouch USB modems"
HOMEPAGE="http://www.speedtouch.com/"
SRC_URI="http://www.speedtouch.com/download/drivers/USB/SpeedTouch330_firmware_${PV//./}.zip"
S=${WORKDIR}

# Taken from http://www.speedtouch.com/driver_upgrade_lx_3.0.1.2.htm
LICENSE="SpeedTouch-USB-Firmware"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="net-dialup/ppp"
BDEPEND="app-arch/unzip"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~FW_LOADER ~NET ~PACKET ~ATM ~NETDEVICES ~USB_DEVICEFS ~USB_ATM ~USB_SPEEDTOUCH \
			~PPP ~PPPOATM ~PPPOE ~ATM_BR2684"
		local WARNING_PPPOATM="CONFIG_PPPOATM:\t is not set (required for PPPoA links)"
		local WARNING_PPPOE="CONFIG_PPPOE:\t is not set (required for PPPoE links)"
		local WARNING_ATM_BR2684="CONFIG_ATM_BR2684:\t is not set (required for PPPoE links)"
		check_extra_config
	fi
}

src_compile() {
	local VER=$(ver_rs 2-4 '')  # {major_ver}.{minor_digits}

	# Extract the "stage 1" portion of the firmware
	edob -m "Extraction of stage 1 firmware (step 1)" \
		dd if=KQD6_${VER} of="${T}/speedtch-1.bin.2" ibs=1 obs=991 count=991 skip=36
	edob -m "Extraction of stage 1 firmware (step 2)" \
		dd if=ZZZL_${VER} of="${T}/speedtch-1.bin.4" ibs=1 obs=935 count=935 skip=32

	# Extract the "stage 2" portion of the firmware
	edob -m "Extraction of stage 2 firmware (step 1)" \
		dd if=KQD6_${VER} of="${T}/speedtch-2.bin.2" ibs=1 obs=762650 count=762650 skip=1027
	edob -m "Extraction of stage 2 firmware (step 2)" \
		dd if=ZZZL_${VER} of="${T}/speedtch-2.bin.4" ibs=1 obs=775545 count=775545 skip=967
}

src_install() {
	# Copy to the firmware directory
	insinto /lib/firmware
	insopts -m 600
	doins "${T}"/speedtch-{1,2}.bin.{2,4}

	# Symlinks for other revisions of the modem
	for n in 1 2 ; do
		dosym speedtch-${n}.bin.2 /lib/firmware/speedtch-${n}.bin.0
		dosym speedtch-${n}.bin.2 /lib/firmware/speedtch-${n}.bin.1
		# Seems like a reasonable guess, for revision 3
		dosym speedtch-${n}.bin.4 /lib/firmware/speedtch-${n}.bin.3
	done

	# Documentation necessary to complete the setup
	dodoc "${FILESDIR}/README"
}

pkg_postinst() {
	[[ -e /etc/hotplug/usb.usermap ]] && grep -E -q " 0x06[bB]9 +0x4061 " /etc/hotplug/usb.usermap && \
		ewarn "Please remove the SpeedTouch line from /etc/hotplug/usb.usermap"

	optfeature "connecting via PPPoA protocol" "net-dialup/ppp[atm]"
	optfeature "connecting via PPPoE protocol" "net-dialup/linux-atm"

	ewarn "To complete the installation, you must read the documentation in"
	ewarn "   ${ROOT}/usr/share/doc/${PF}"
}
