# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info

MY_P="iwlwifi-${P#iwl}"

DESCRIPTION="Firmware for Intel (R) Wireless 8260 and 4165"
HOMEPAGE="https://wireless.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/${MY_P}.tgz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	!sys-kernel/linux-firmware[-savedconfig]
"

CONFIG_CHECK="~IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the ${DEV_N} firmware"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if kernel_is lt 4 3 0; then
		eerror "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		eerror "This microcode image requires a kernel >= 4.3.0."
	fi
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-8000C-16.ucode
	dodoc README*
}
