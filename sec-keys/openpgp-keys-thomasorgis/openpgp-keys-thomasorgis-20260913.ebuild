# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'D021FF8ECF4BE09719D61A27231C4CBC60D5CAFE:thomas:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Thomas Orgis"
HOMEPAGE="https://thomas.orgis.org/ https://www.mpg123.org/download.shtml"
SRC_URI+=" http://thomas.orgis.org/public_key -> ${P}.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
