# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://rsync.samba.org/download.html ("Release signing keys")

SEC_KEYS_VALIDPGPKEYS=(
	'C0E1054505704F757D925AB26A64E8AA2EFBCF5D:steadytao:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Zen Dodd"
HOMEPAGE="https://rsync.samba.org/download.html https://github.com/steadytao"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
