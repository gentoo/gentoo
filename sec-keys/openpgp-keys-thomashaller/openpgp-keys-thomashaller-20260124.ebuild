# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	49EA7C670E0850E7419514F629C2366E4DFC5728:thom311:github
	67DA3FAEBAE276BA58FC6CE314F18A98993AECD5:thom311:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Thomas Haller"
HOMEPAGE="https://github.com/thom311"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
