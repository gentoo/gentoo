# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	12538F8F689B5F1F15F07BE1765FE26C6B467584:strongswan-nm:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for networkmanager-strongswan releases"
HOMEPAGE="https://www.strongswan.org/download.html"
SRC_URI="https://download.strongswan.org/STRONGSWAN-NM-RELEASE-PGP-KEY -> ${P}-STRONGSWAN-NM-RELEASE-PGP-KEY.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
