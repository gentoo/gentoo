# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'DA7D64E4C82C6294CB73A20E22E3D13B5411B7CA:bradh352:github,ubuntu,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Brad House (bradh352)"
HOMEPAGE="https://bradhouse.dev/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
