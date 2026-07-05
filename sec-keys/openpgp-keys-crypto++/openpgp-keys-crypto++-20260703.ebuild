# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'B8CC19802062211A508B2F5CCE0586AF1F8E37BD:noloader:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign crypto++ releases"
HOMEPAGE="https://cryptopp.com/signing.html"

KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
