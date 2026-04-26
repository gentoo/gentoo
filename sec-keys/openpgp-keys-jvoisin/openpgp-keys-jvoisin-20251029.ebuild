# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'9FCDEE9E1A381F311EA62A7404D041E8171901CC:jvoisin:openpgp,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Julien Voisin"
HOMEPAGE="https://dustri.org/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
