# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"9FB5E737DC25B29D8EEC469142F3F1862E3CC4B8:ddevault:manual"
)

inherit sec-keys

DESCRIPTION="Drew DeVault's PGP signing key"
HOMEPAGE="https://drewdevault.com/"
SRC_URI="https://drewdevault.com/publickey.txt"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
