# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

DESCRIPTION="Firmware for Intel (R) Wireless 3160, 7260, 7265 Bluetooth"
HOMEPAGE="https://wireless.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="mirror://gentoo/${P}.tgz"
S="${WORKDIR}"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!sys-kernel/linux-firmware[-savedconfig]"

CONFIG_CHECK="~IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the Intel (R) Wireless 3160, 7260, 7265 firmware"

pkg_pretend() {
	if kernel_is lt 3 10 0; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		ewarn "This microcode image requires a kernel >= 3.10.0."
	fi
}

src_install() {
	insinto /lib/firmware
	doins -r intel
}
