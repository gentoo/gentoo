# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

DEV_N="${PN:3:4}"
MY_PV="$(ver_cut 2).$(ver_cut 3).$(ver_cut 1)"
MY_PN="iwlwifi-${DEV_N}-ucode"

DESCRIPTION="Firmware for Intel (R) Dual Band Wireless-AC ${DEV_N}"
HOMEPAGE="https://wireless.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/${MY_PN}-${MY_PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="ipw3945"
SLOT="$(ver_cut 2)"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

RDEPEND="
	bluetooth? ( sys-firmware/iwl3160-7260-bt-ucode )
	!sys-kernel/linux-firmware[-savedconfig]"

CONFIG_CHECK="~IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the ${DEV_N} firmware"

src_install() {
	insinto /lib/firmware
	doins iwlwifi-${DEV_N}-$(ver_cut 2).ucode
	dodoc README*
}
