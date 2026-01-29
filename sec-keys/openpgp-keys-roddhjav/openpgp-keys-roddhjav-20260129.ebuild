# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	#06A26D531D56C42D66805049C5469996F0DF68EC:roddhjav:github
	61F02B21BA2503A526345A40E0CC7D788DA0EBF2:master:manual
	06A26D531D56C42D66805049C5469996F0DF68EC:code:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Alexandre Pujol (roddhjav)"
HOMEPAGE="https://pujol.io/keys/"
SRC_URI+=" https://pujol.io/keys/0xe0cc7d788da0ebf2.asc"
SRC_URI+=" https://pujol.io/keys/0xc5469996f0df68ec.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
