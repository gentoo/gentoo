# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'2A7C7DDFCEEF0F68C8E13AF5549F26C800B4701F:drwetter:openpgp'
	'D8342DA2F5041387E17F4CA14D9CA7F2E2FA20B3:testssl:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by testssl.sh"
HOMEPAGE="https://testssl.sh/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
