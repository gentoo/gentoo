# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit savedconfig

DESCRIPTION="Broadcom Bluetooth firmware"
HOMEPAGE="https://github.com/winterheart/broadcom-bt-firmware"
SRC_URI="https://github.com/winterheart/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="broadcom_bcm20702 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="savedconfig"

src_prepare() {
	default

	# Depending on the Bluetooth device and the hardware configuration, Linux kernel
	# expects firmware to be found under slightly different file names.

	## Create a config file with sensible default values

	echo "# Remove or comment out files that shall not be installed from this list." > ${PN}.conf || die
	echo "# If your kernel looks for firmware under a different file name," >> ${PN}.conf || die
	echo "# specify the new name in the second column." >> ${PN}.conf || die

	# Start with the verbatim file list
	find brcm -type f -name '*.hcd' -print > ${PN}.conf.tmp || die
	sort ${PN}.conf.tmp >> ${PN}.conf || die
	rm ${PN}.conf.tmp || die

	# Apply firmware file name changes where it is necessary and possible to do so unambiguously
	sed -i -E -e 's:^(brcm/(BCM20702A1|BCM4335C0)([0-9a-f-]+)\.hcd)$:\1\t# brcm/\2.hcd:g' ${PN}.conf || die
	sed -i -E -e 's:^(brcm/(BCM20702B0)([0-9a-f-]+)\.hcd)$:\1\t# brcm/BCM43341B0.hcd:g' ${PN}.conf || die
	sed -i -E -e 's:^(brcm/(BCM4356A2)([0-9a-f-]+)\.hcd)$:\1\tbrcm/BCM4354A2\3.hcd\t# brcm/\2.hcd:g' ${PN}.conf || die
	sed -i -E -e 's:^(brcm/(BCM20703A1|BCM4350C5|BCM4371C2)([0-9a-f-]+)\.hcd)$:\1\tbrcm/BCM\3.hcd:g' ${PN}.conf || die

	# Remove redundant firmware that is also part of sys-kernel/linux-firmware
	sed -i -E -e 's:^(\S+\s+brcm/BCM-0bb4-0306.hcd)$:# \1:g' ${PN}.conf || die

	## Use either the default config above or load the user's saved config
	if use savedconfig; then
		restore_config ${PN}.conf
	fi

	## Prepare firmware file list based on the config file

	# Strip comments and extra whitespaces, add second column where missing
	sed -E -e 's/\s*#.*$//g' -e '/^$/d' -e 's/\s+/ /g' -e 's/^(\S+)$/\1 \1/g' ${PN}.conf > ${PN}.conf.tmp || die

	# Remove unneeded files and rename those that are requested in the config file
	local ARGS
	for FW in $(find brcm -type f -name '*.hcd' -print || die); do
		ARGS=$(grep -F "${FW}" ${PN}.conf.tmp)
		if [[ $? == 0 ]]; then
			mv -v -n ${ARGS} || die
		else
			rm -v ${FW} || die
		fi
	done
	rm ${PN}.conf.tmp || die
}

src_install() {
	# Save config regardless of the USE flag
	save_config ${PN}.conf
	rm ${PN}.conf || die

	# Copy over all remaining firmware files
	insinto /lib/firmware
	doins -r brcm
}

pkg_postinst() {
	if ! use savedconfig; then
		elog ""
		elog "Depending on your hardware configuration, kernel might look for firmware"
		elog "files under a different name than this package installs it. Please check"
		elog "'dmesg' for errors, and edit the saved config file to install them with"
		elog "the correct name."
	fi
}
