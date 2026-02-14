# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	34FF9526CFEF0E97A340E2E40FDE7BE0E88F5E48:emersion:openpgp,ubuntu,manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Simon Ser"
HOMEPAGE="https://emersion.fr/about/"
SRC_URI+=" https://emersion.fr/.well-known/openpgpkey/hu/dj3498u4hyyarh35rkjfnghbjxug6b19 -> emersion-${PV}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
