# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-mod-r1 udev unpacker

DESCRIPTION="aic8800 driver for AICSemi AIC8800/8801/8800DC/8800DW/8800FC Wifi/Bluetooth"
HOMEPAGE="https://www.aicsemi.com/ https://linux.brostrend.com/troubleshooting/source-code/"

SRC_URI="https://linux.brostrend.com/${PN}-dkms.deb -> ${P}.deb"

LICENSE="GPL-2+ firmware? ( freedist )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+firmware udev"

CONFIG_CHECK="MAC80211 USB ~BT_HCIBTUSB"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.6-linux-6.12.patch"
	"${FILESDIR}/${PN}-1.0.6-linux-6.1.patch"
)

BDEPEND+="
	$(unpacker_src_uri_depends)"

S="${WORKDIR}/usr/src/${P}"

src_compile() {
	MODULES_MAKEARGS+=(
		KDIR="${KV_OUT_DIR}"
	)
	emake "${MODULES_MAKEARGS[@]}"
}

src_install() {
	linux_moduleinto kernel/drivers/net/wireless/${PN}
	linux_domodule aic8800_fdrv/aic8800_fdrv.ko aic_load_fw/aic_load_fw.ko
	modules_post_process
	if use firmware; then
		insinto /lib/firmware
		doins -r "${WORKDIR}/lib/firmware/aic8800DC"
	fi
	if use udev; then
		# install udev rules for USB mode switching
		udev_newrules "${WORKDIR}/lib/udev/rules.d/aic.rules" 99-aic-modeswitch.rules
	fi
}

pkg_postinst() {
	if use udev; then
		udev_reload
	fi
	linux-mod-r1_pkg_postinst
}

pkg_postrm() {
	if use udev; then
		udev_reload
	fi
}
