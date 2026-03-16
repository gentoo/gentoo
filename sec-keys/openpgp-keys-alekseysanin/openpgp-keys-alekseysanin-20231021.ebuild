# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"00FDD6A7DFB81C88F34B9BF0E63ECDEF9E1D829E:aleksey@aleksey.com:manual"
)

inherit sec-keys

DESCRIPTION="Aleksey Sanin OpenPGP Key"
HOMEPAGE="https://www.aleksey.com/xmlsec/"
SRC_URI="https://www.aleksey.com/xmlsec/download/aleksey%40aleksey.com.gpg"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
