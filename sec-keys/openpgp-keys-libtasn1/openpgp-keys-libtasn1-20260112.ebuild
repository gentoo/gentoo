# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	B1D2BD1375BECB784CF4F8C4D73CF638C53C06BE:josefsson1:manual
	0424D4EE81A0E3D119C6F835EDA21E94B565716F:josefsson2:manual
	9AA9BDB11BB1B99A21285A330664A76954265E8C:nmav:manual
	1F42418905D8206AA754CCDC29EE58B996865171:josefsson3:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GNU Libtasn1"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
# Listed at https://www.gnu.org/software/libtasn1/
SRC_URI="
	https://josefsson.org/key-20190320.txt -> ${P}-josefsson-key-20190320.txt
	https://josefsson.org/54265e8c.txt -> ${P}-josefsson-54265e8c.txt
	https://members.hellug.gr/nmav/pgpkeys.asc -> ${P}-nmav-pgpkeys.asc
	https://josefsson.org/key.txt -> ${P}-josefsson-key.txt
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
