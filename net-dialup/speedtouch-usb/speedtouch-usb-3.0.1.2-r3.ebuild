# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/speedtouch-usb/speedtouch-usb-3.0.1.2-r3.ebuild,v 1.3 2013/11/06 03:52:16 patrick Exp $

inherit eutils linux-info

DESCRIPTION="Firmware, kernel driver and configuration instructions for Alcatel SpeedTouch USB modems"
HOMEPAGE="http://www.speedtouch.com/"
SRC_URI="http://www.speedtouch.com/download/drivers/USB/SpeedTouch330_firmware_${PV//./}.zip"

# Taken from http://www.speedtouch.com/driver_upgrade_lx_3.0.1.2.htm
LICENSE="SpeedTouch-USB-Firmware"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="net-dialup/ppp"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 10 ; then
		eerror "The kernel-space driver exists only in kernels >= 2.6.10."
		eerror "Please upgrade the kernel."
		die "Unsupported kernel version"
	fi
}

src_install() {
	local FILE_VER="${PV#*.}"
	FILE_VER="${PV%%.*}.${FILE_VER//./}"  # {major_ver}.{minor_digits}

	# Extract the "stage 1" portion of the firmware
	dd if=KQD6_${FILE_VER} of=speedtch-1.bin.2 \
		ibs=1 obs=991 count=991 skip=36 &> /dev/null \
		|| die "Extraction of stage 1 firmware (step 1) failed"

	dd if=ZZZL_${FILE_VER} of=speedtch-1.bin.4 \
		ibs=1 obs=935 count=935 skip=32 &> /dev/null \
		|| die "Extraction of stage 1 firmware (step 2) failed"

	# Extract the "stage 2" portion of the firmware
	dd if=KQD6_${FILE_VER} of=speedtch-2.bin.2 \
		ibs=1 obs=762650 count=762650 skip=1027 &> /dev/null \
		|| die "Extraction of stage 2 firmware (step 1) failed"

	dd if=ZZZL_${FILE_VER} of=speedtch-2.bin.4 \
		ibs=1 obs=775545 count=775545 skip=967 &> /dev/null \
		|| die "Extraction of stage 2 firmware (step 2) failed"

	# Copy to the firmware directory
	insinto /lib/firmware
	insopts -m 600
	doins speedtch-{1,2}.bin.{2,4} || die "doins firmware failed"

	# Symlinks for other revisions of the modem
	cd "${D}/lib/firmware"
	for n in 1 2 ; do
		for rev in 0 1 ; do
			ln -sfn speedtch-${n}.bin.2 speedtch-${n}.bin.${rev}
		done
		# Seems like a reasonable guess, for revision 3
		ln -sfn speedtch-${stub}${n}.bin.4 speedtch-${n}.bin.3
	done

	# Documentation necessary to complete the setup
	dodoc "${FILESDIR}/README" || die "dodoc failed"
}

pkg_postinst() {
	[[ -e /etc/hotplug/usb.usermap ]] && egrep -q " 0x06[bB]9 +0x4061 " /etc/hotplug/usb.usermap && \
		ewarn "Please remove the SpeedTouch line from /etc/hotplug/usb.usermap"

	# Check kernel configuration
	local CONFIG_CHECK="~FW_LOADER ~NET ~PACKET ~ATM ~NETDEVICES ~USB_DEVICEFS ~USB_ATM ~USB_SPEEDTOUCH \
		~PPP ~PPPOATM ~PPPOE ~ATM_BR2684"
	local WARNING_PPPOATM="CONFIG_PPPOATM:\t is not set (required for PPPoA links)"
	local WARNING_PPPOE="CONFIG_PPPOE:\t is not set (required for PPPoE links)"
	local WARNING_ATM_BR2684="CONFIG_ATM_BR2684:\t is not set (required for PPPoE links)"
	check_extra_config
	echo

	# Check user-space for PPPoA support
	if ! built_with_use net-dialup/ppp atm ; then
		ewarn "Run the following command if connecting via PPPoA protocol:"
		ewarn "   euse -E atm && emerge net-dialup/ppp"
		echo
	fi
	# Check user-space for PPPoE support
	if ! has_version >=net-dialup/linux-atm-2.5.0 ; then
		ewarn "Run the following command if connecting via PPPoE protocol:"
		ewarn "   emerge net-dialup/linux-atm"
		echo
	fi

	ewarn "To complete the installation, you must read the documentation in"
	ewarn "   ${ROOT}usr/share/doc/${PF}"
}
