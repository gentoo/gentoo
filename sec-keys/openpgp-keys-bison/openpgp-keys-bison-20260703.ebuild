# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# openpgp, no user id
	'155D3FC500C834486D1EEA677FD9FCCB000BEEEE:meyering:manual,ubuntu'
	'2B7C1A53420D4AF3BFF4738BF382AE19F4850180:eblake1:manual,ubuntu'
	'63B16683841CE3DC25D3C6EB421AFA26387F9A8E:bob:manual,ubuntu,openpgp'
	'71C2CC22B1C4602927D2F3AAA7A16B4A2527436A:eblake2:manual,ubuntu'
	'7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E:akim:manual,ubuntu'
	'7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34:eggert:manual,ubuntu'
	'A4F4CBDB67EE745D1824F07EB7F0DD78CD1759CB:joeldenny:manual,ubuntu'
	'A78EDBD82850EDFE8C7F9850A309D67919A22547:polak:manual,ubuntu'
	'C28DA2F8435AF1B3C563CC7C17EB3CBCA7EE17A2:rozenman:manual,ubuntu'
	'EDFAB4C9554BDF6AD29A47D57FFE5E4115598D5E:yyu:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Bison"
HOMEPAGE="https://savannah.gnu.org/projects/bison"
SRC_URI+=" https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=bison&download=1 -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
