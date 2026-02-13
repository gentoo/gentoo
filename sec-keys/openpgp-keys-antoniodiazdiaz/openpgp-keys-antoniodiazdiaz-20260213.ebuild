# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# Old DSA1024 key
	1D41C14B272A2219A739FA4F8FE99503132D7742:dsa:manual
	# New RSA4096 key
	1E5AEE0B18C0DEB45D64AA0325B62C9821501AA0:rsa:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Antonio Diaz Diaz"
HOMEPAGE="https://savannah.gnu.org/users/antonio"
SRC_URI="https://savannah.gnu.org/people/viewgpg.php?user_id=12809 -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
