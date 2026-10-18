# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34:eggert:github,ubuntu,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Paul Eggert"
HOMEPAGE="https://github.com/eggert"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
