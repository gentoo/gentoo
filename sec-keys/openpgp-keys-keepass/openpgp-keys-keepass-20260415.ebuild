# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D95044283EE948D911E8B606A4F762DC58C6F98E:dominik:manual,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by KeePass"
HOMEPAGE="https://keepass.info/integrity.html"
SRC_URI+=" https://keepass.info/integrity/DominikReichl.asc -> ${P}-DominikReichl.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
