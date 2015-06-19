# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl3160-ucode/iwl3160-ucode-0.10.15.23.ebuild,v 1.1 2015/03/25 03:59:38 gienah Exp $

EAPI=5
inherit linux-info versionator

DEV_N="${PN:3:4}"
vc=($(get_all_version_components "${PV}"))
MY_PV="${vc[6]}.${vc[4]}.${vc[2]}.${vc[0]}"
MY_PN="iwlwifi-${DEV_N}-ucode"

DV_MAJOR="3"
DV_MINOR="17"
DV_PATCH="0"

DESCRIPTION="Firmware for Intel (R) Dual Band Wireless-AC ${DEV_N}"
HOMEPAGE="http://wireless.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/${MY_PN}-${MY_PV}.tgz -> ${P}.tgz"

LICENSE="ipw3945"
SLOT="${vc[2]}"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

DEPEND=""
RDEPEND="bluetooth? ( sys-firmware/iwl3160-7260-bt-ucode )
	!sys-kernel/linux-firmware[-savedconfig]"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

CONFIG_CHECK="~IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the ${DEV_N} firmware"

pkg_pretend() {
	if kernel_is lt "${DV_MAJOR}" "${DV_MINOR}" "${DV_PATCH}"; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		ewarn "This microcode image requires a kernel >= ${DV_MAJOR}.${DV_MINOR}.${DV_PATCH}."
		ewarn "For kernel versions < ${DV_MAJOR}.${DV_MINOR}.${DV_PATCH}, you may install older SLOTS"
	fi
}

src_install() {
	insinto /lib/firmware
	doins "${S}/iwlwifi-${DEV_N}-${vc[2]}.ucode"
	dodoc README*
}
