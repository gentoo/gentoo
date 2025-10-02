# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT_ID="2bbfb8438e824f5f61dae3f6ebb367a6129a4d63"

DESCRIPTION="Firmware for Broadcom BCM, STLC2300, and Synaptics SYN Bluetooth chips"
HOMEPAGE="https://github.com/RPi-Distro/bluez-firmware"
SRC_URI="
	https://github.com/RPi-Distro/bluez-firmware/archive/${COMMIT_ID}.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}/bluez-firmware-${COMMIT_ID}"
LICENSE="bluez-firmware GPL-2+"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

RESTRICT="bindist mirror"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	econf --libdir=/lib
}

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /lib/firmware/brcm
	doins debian/firmware/broadcom/*.hcd

	insinto /lib/firmware/synaptics
	doins debian/firmware/synaptics/*.hcd
}
