# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'3057EE9A448F362D74205A779AB120DA0A76F6DE:ales.mrazek:openpgp'
	'B6006460B60A80E782062449E747DF1F9575A3AA:vladimir.cunat:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the Knot Resolver developers"
HOMEPAGE="https://www.knot-resolver.cz/download/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
