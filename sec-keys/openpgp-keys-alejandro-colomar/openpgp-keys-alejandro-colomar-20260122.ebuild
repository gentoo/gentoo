# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'A9348594CE31283A826FBDD8D57633D441E25BB5:alejandro-colomar:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Alejandro Colomar"
HOMEPAGE="https://github.com/alejandro-colomar"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
