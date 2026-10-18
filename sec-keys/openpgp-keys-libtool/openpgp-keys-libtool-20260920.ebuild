# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'02D974AB062F7B665136D019FEBD9993F5C88A51:bruce.korb:manual'
	'155D3FC500C834486D1EEA677FD9FCCB000BEEEE:jim.meyering:manual'
	'2B7C1A53420D4AF3BFF4738BF382AE19F4850180:eric.blake:manual'
	'71C2CC22B1C4602927D2F3AAA7A16B4A2527436A:eric.blake2:manual'
	'357D7084216BD1CF46AFABB232419B785D0CDCFC:ralf.wildenhues:manual'
	'4B6DBBF82054C23F20F916DE771FEDD1409580AB:pavel.raiskup:manual,ubuntu'
	'4D671997DD32AE8ED7ED9C7984912AB7DF3B6004:peter.o.gorman:manual,ubuntu'
	'564A180D1D88DE909F53EC688D4AE004BE425C25:robert.boehne:manual'
	'7C5FBB96BE82B954AC20DF5F6EAC957F8EEB55C0:alex.ameen:manual'
	'7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E:akim.demaille:manual,ubuntu'
	'7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34:paul.eggert:manual,ubuntu,openpgp'
	'B902B5271325F892AC251AD441633B9FE837F581:mike.frysinger:manual,ubuntu,openpgp'
	'C5B91BDAF3A89934720FBAB4C3013AEF00BC3D49:benoit.sigoure:manual'
	'D363BF126B7F7F6FCDCE4F755234845DF2B920F5:alexandre.oliva:manual,ubuntu'
	'FA26CA784BE188927F22B99F6570EA01146F7354:ileana.dumitrescu:manual,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU libtool"
HOMEPAGE="https://savannah.gnu.org/projects/libtool/"
SRC_URI+=" https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=libtool&download=1 -> ${P}.asc"
# emailed Ileana on 2026-09-20
SRC_URI+=" https://lists.gnu.org/archive/html/info-gnu/2026-07/binoWdoAfOW9p.bin -> ${P}-ileana-renewed.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
