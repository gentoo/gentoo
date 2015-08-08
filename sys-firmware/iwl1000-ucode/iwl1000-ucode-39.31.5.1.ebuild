# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-info

MY_P="iwlwifi-1000-ucode-${PV}"
DESCRIPTION="Intel (R) Wireless WiFi Link 1000BGN ucode"
HOMEPAGE="http://intellinuxwireless.org/?p=iwlwifi"
SRC_URI="http://intellinuxwireless.org/iwlwifi/downloads/${MY_P}.tgz"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if kernel_is lt 2 6 39; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		ewarn "This microcode image requires a kernel >= 2.6.39."
		ewarn "For kernel versions < 2.6.39, you may unmask and install"
		ewarn "${CATEGORY}/${PN}-128.50.3.1 instead."
	fi
}

src_install() {
	insinto /lib/firmware
	doins iwlwifi-1000-5.ucode
	dodoc README.iwlwifi-1000-ucode
}
