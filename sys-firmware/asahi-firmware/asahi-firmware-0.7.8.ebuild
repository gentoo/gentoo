# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

_name=asahi-installer

DESCRIPTION="Asahi FW extraction script"
HOMEPAGE="https://asahilinux.org"
SRC_URI="https://github.com/AsahiLinux/${_name}/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${_name}-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

DEPEND=">=sys-apps/asahi-scripts-20230606"
RDEPEND="${DEPEND}
	app-arch/lzfse
	sys-kernel/linux-firmware
"

src_install() {
	distutils-r1_src_install
	keepdir /lib/firmware/vendor/
}

pkg_postinst() {
	elog "Asahi vendor firmware update script"
	elog "Please run 'asahi-fwupdate' after each update of this package."

	if [ -e ${ROOT}/bin/update-vendor-fw -o -e ${ROOT}/etc/local.d/apple-firmware.start ]; then
		ewarn "Please remember to remove '/{s}bin/update-vendor-fw' and"
		ewarn "'/etc/local.d/apple-firmware.start'"
	fi

	if [ -e ${ROOT}/etc/local.d/asahi-firmware.start ]; then
		ewarn "Please remove /etc/local.d/asahi-firmware.start as it is"
		ewarn "obsolete and no longer required."
	fi

	if [ -e ${ROOT}/sbin/update-vendor-firmware ]; then
		ewarn "Please remove /sbin/update-vendor-firmware"
	fi
}
