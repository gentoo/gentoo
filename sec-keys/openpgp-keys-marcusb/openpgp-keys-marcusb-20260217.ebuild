# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	9FCFF9AEE365B2A8918FD3576CA3CD34C6363576:marcusb:manual,openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Marcus Butler (marcusb)"
HOMEPAGE="https://marcusb.org/contact.html"
SRC_URI+=" https://marcusb.org/9FCFF9AEE365B2A8918FD3576CA3CD34C6363576.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
