# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	51A0F4A0C8CFC98F842EA9A8B94556F81C85D0D5:alisarctl:github
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Ali Abdallah"
HOMEPAGE="https://github.com/alisarctl"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
