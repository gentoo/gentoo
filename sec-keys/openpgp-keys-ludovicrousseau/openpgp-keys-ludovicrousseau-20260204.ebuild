# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	0AB8E37F4E12D95D6FE26AF2CCF072ED09712A89:ludovic4096:manual
	F5E11B9FFE911146F41D953D78A1B4DFE8F9C57E:ludovic3072:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Ludovic Rousseau"
HOMEPAGE="http://ludovic.rousseau.free.fr/"
SRC_URI="
	http://ludovic.rousseau.free.fr/gpg_key_E8F9C57E.txt
	http://ludovic.rousseau.free.fr/gpg_key_CCF072ED09712A89.txt
"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
