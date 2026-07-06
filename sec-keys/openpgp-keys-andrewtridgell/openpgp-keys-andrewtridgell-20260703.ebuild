# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See GPG singing key instructions here https://rsync.samba.org/download.html
# https://www.samba.org/~tridge/ contains the email signing key rather than release singing key

SEC_KEYS_VALIDPGPKEYS=(
	'9FEF112DCE19A0DC7E882CB81BB24997A8535F6F:andrewtridgell:ubuntu,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Andrew Tridgell"
HOMEPAGE="https://www.samba.org/~tridge/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
