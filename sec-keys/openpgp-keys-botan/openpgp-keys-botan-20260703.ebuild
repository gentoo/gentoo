# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# openpgp, no user id
	'621DAF6411E1851C4CF9A2E16211EBF1EFBADFBC:botan:manual,ubuntu'
	'4E60C73551AF2188DF0A5A6278E9804357123B60:jack1:manual,ubuntu,openpgp'
	'117510149DF418ABD19CB06D9FFD596FAB50F90D:jack2:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign Botan releases"
HOMEPAGE="https://botan.randombit.net"
SRC_URI+=" https://botan.randombit.net/pgpkey.txt -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
