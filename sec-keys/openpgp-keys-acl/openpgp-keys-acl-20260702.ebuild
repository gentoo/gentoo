# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'259B3792B3D6D319212CC4DCD5BF9FEB0313653A:agruen:manual'
	'600CD204FBCEA418BD2CA74F154343260542DF34:brandon:manual,ubuntu'
	'B902B5271325F892AC251AD441633B9FE837F581:vapier:manual,gentoo'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by sys-apps/acl"
HOMEPAGE="https://savannah.nongnu.org/projects/acl"
SRC_URI+=" https://savannah.nongnu.org/project/memberlist-gpgkeys.php?group=acl&download=1 -> ${P}.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
