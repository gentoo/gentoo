# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'D8D14B91ACAF41E231F8686728E4B7253029E7F6:bstansell:github,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the conserver developer"
HOMEPAGE="https://conserver.com"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
