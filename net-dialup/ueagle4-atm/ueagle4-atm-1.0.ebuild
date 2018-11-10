# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-info

DESCRIPTION="Firmware and configuration instructions for Eagle USB E4 ADSL Modem driver"
HOMEPAGE="https://gna.org/projects/ueagleatm/"
SRC_URI="http://eagle-usb.org/ueagle-atm/non-free/ueagle4-data-${PV}.tar.gz"

LICENSE="Ikanos"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="net-dialup/ppp
	!sys-kernel/linux-firmware"

S="${WORKDIR}/ueagle4-data-${PV}"

src_install() {
	# Copy to the firmware directory
	insinto /lib/firmware/ueagle-atm
	doins *

	# Documentation necessary to complete the setup
	dodoc "${FILESDIR}/README"
}

pkg_postinst() {
	# Check kernel configuration
	local CONFIG_CHECK="~FW_LOADER ~NET ~PACKET ~ATM ~NETDEVICES ~USB_DEVICEFS ~USB_ATM ~USB_UEAGLEATM \
		~PPP ~PPPOATM ~PPPOE ~ATM_BR2684"
	local WARNING_PPPOATM="CONFIG_PPPOATM:\t is not set (required for PPPoA links)"
	local WARNING_PPPOE="CONFIG_PPPOE:\t is not set (required for PPPoE links)"
	local WARNING_ATM_BR2684="CONFIG_ATM_BR2684:\t is not set (required for PPPoE links)"
	check_extra_config
	echo

	# Check user-space for PPPoA support
	if ! has_version net-dialup/ppp[atm] ; then
		ewarn "Run the following command if connecting via PPPoA protocol:"
		ewarn "   euse -E atm && emerge net-dialup/ppp"
		echo
	fi
	# Check user-space for PPPoE support
	if ! has_version net-dialup/linux-atm ; then
		ewarn "Run the following command if connecting via PPPoE protocol:"
		ewarn "   emerge net-dialup/linux-atm"
		echo
	fi

	ewarn "To complete the installation, you must read the documentation in"
	ewarn "   ${ROOT}usr/share/doc/${PF}"
}
