# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# expiration 2026-09-10
SEC_KEYS_VALIDPGPKEYS=(
	'A9E582E4054A159315EDC943D6D447B02B4D4C9D:andrewziem:openpgp,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the BleachBit developer"
HOMEPAGE="https://www.bleachbit.org/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
