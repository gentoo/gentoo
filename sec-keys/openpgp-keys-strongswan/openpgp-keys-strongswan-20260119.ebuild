# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	948F158A4E76A27BF3D07532DF42C170B34DBA77:strongswan:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for strongswan releases"
HOMEPAGE="https://www.strongswan.org/download.html"
SRC_URI="https://download.strongswan.org/STRONGSWAN-RELEASE-PGP-KEY -> ${P}-STRONGSWAN-RELEASE-PGP-KEY.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
