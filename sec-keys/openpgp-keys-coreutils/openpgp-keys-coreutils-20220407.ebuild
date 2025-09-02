# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'155D3FC500C834486D1EEA677FD9FCCB000BEEEE:jim.meyering:manual'
	'2B7C1A53420D4AF3BFF4738BF382AE19F4850180:eblake:manual'
	'71C2CC22B1C4602927D2F3AAA7A16B4A2527436A:eblake2:manual'
	'63B16683841CE3DC25D3C6EB421AFA26387F9A8E:bob.proulx:manual'
	'7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34:eggert:manual'
	'6C37DC12121A5006BC1DB804DF6FD971306037D9:pixelb:manual'
	'A5189DB69C1164D33002936646502EF796917195:bernhard.voelker:manual'
	'F576AAAC1B0FF849792D8CB129A794FD2272BC86:assaf.gordon:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU coreutils"
HOMEPAGE="https://savannah.gnu.org/projects/coreutils/"
SRC_URI="https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=coreutils&download=1 -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
