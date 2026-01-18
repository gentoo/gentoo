# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	CF3A93EF01E616C5AE7A1D2745E1E473378BB197:colordiff:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Andreas Enge (to sign MPC releases)"
# https://www.colordiff.org/ -> https://www.sungate.co.uk/?page_id=203
HOMEPAGE="https://www.sungate.co.uk/?page_id=203"
SRC_URI="https://www.sungate.co.uk/gpgkey_2013.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
