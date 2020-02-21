# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

MY_P="iwlwifi-${P#iwl}"

DESCRIPTION="Intel (R) Wireless WiFi Link 6250-AGN ucode"
HOMEPAGE="https://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="https://intellinuxwireless.org/iwlwifi/downloads/${MY_P}.tgz"

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
	if kernel_is lt 2 6 37; then
		eerror "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		eerror "This microcode image requires a kernel >= 2.6.37."
	fi
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-6050-5.ucode
	dodoc README*
}
