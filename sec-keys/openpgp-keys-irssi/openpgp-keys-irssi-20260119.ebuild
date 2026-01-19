# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	7EE65E3082A5FB06AC7C368D00CCB587DDBEF0E1:irssi:openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for irssi releases"
HOMEPAGE="https://irssi.org/download/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
