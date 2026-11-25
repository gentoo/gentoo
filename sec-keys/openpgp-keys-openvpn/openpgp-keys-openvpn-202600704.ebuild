# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	F554A3687412CFFEBDEFE0A312F5F7B42F2B01E7:openvpn:openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for OpenVPN releases"
HOMEPAGE="https://community.openvpn.net/Downloads/Verify%20signature"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
