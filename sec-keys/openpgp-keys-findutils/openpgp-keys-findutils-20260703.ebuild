# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'0CF4E8D871593224842832B888DD9E08C5DDACB9:jay:manual,ubuntu'
	'2B7C1A53420D4AF3BFF4738BF382AE19F4850180:eblake1:manual,ubuntu'
	'63B16683841CE3DC25D3C6EB421AFA26387F9A8E:bob:manual,ubuntu,openpgp'
	'71C2CC22B1C4602927D2F3AAA7A16B4A2527436A:eblake2:manual,ubuntu'
	'A5189DB69C1164D33002936646502EF796917195:bernhardvoelker:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU findutils"
HOMEPAGE="https://savannah.gnu.org/projects/findutils/"
SRC_URI+=" https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=findutils&download=1 -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
