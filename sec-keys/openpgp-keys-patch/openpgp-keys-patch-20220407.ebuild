# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'155D3FC500C834486D1EEA677FD9FCCB000BEEEE:jim.meyering:manual'
	'259B3792B3D6D319212CC4DCD5BF9FEB0313653A:agruen:manual'
	'7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34:eggert:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU patch"
HOMEPAGE="https://savannah.gnu.org/projects/patch/"
SRC_URI="https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=patch&download=1 -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
