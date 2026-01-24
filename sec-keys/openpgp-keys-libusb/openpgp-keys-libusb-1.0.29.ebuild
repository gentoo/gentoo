# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C68187379B23DE9EFC46651E2C80FF56C6830A0E:tormod:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by dev-libs/libusb"
HOMEPAGE="https://github.com/libusb/libusb/blob/master/KEYS"
SRC_URI="https://raw.githubusercontent.com/libusb/libusb/refs/tags/v${PV}/KEYS -> ${P}-libusb-KEYS.txt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
