# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	F8F1BEA490496A09CCA328CC38C1F572B12725BE:erwin:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Erwin Waterlander"
HOMEPAGE="https://waterlander.net/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
