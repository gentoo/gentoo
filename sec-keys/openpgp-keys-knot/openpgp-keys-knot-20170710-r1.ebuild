# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'742FA4E95829B6C5EAC6B85710BB7AF6FEBBD6AB:daniel.salzman:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the Knot DNS developers"
HOMEPAGE="https://www.knot-dns.cz/download/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
