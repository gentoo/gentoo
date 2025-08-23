# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'3690C240CE51B4670D30AD1C38EE757D69184620:Larhzu:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Lasse Collin"
HOMEPAGE="https://tukaani.org/xz/"
SRC_URI="https://tukaani.org/misc/lasse_collin_pubkey.txt -> ${P}-lasse_collin_pubkey.txt"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
