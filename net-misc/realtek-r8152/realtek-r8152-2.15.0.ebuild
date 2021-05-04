# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod linux-info udev

SRC_URI="https://github.com/slashbeast/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Out-of-tree driver for Realtek's 2.5 GbE USB NICs."
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-usb-3-0-software"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"
RDEPEND=""

MODULE_NAMES="r8152(net/usb)"

pkg_setup() {
	linux_config_exists

	for module in USB_USBNET USB_NET_CDC_NCM USB_NET_CDCETHER; do
		linux_chkconfig_module "${module}" || ewarn "CONFIG_${module} needs to be built as module (builtin doesn't work)"
	done

	linux_chkconfig_present MII || ewarn "CONFIG_MII needs to be built as module or builtin into the kernel"

	linux_chkconfig_present USB_RTL8152 && ewarn "CONFIG_USB_RTL8152 must NOT be enabled in the kernel!"

	linux-mod_pkg_setup

	BUILD_TARGETS="modules"
	BUILD_PARAMS="CC=$(tc-getBUILD_CC) KERNELDIR=${KERNEL_DIR}"
}

src_install() {
	linux-mod_src_install

	udev_newrules 50-usb-realtek-net.rules 50-usb-realtek-net.rules
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	echo
	elog "If the cdc_ncm was loaded before this r8152 driver, one might get a flood"
	elog "of 'usbN: network connection: disconnected' in kernel log."
	elog "In that case one needs to unload r8152, cdc_ether and cdc_ncm modules and"
	elog "let udev load them in right order or manually load r8152."
	echo
}
