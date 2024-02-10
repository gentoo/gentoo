# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by GNU Libtasn1"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
# Listed at https://www.gnu.org/software/libtasn1/
SRC_URI="
	https://josefsson.org/key-20190320.txt -> ${P}-josefsson-key-20190320.txt
	https://josefsson.org/54265e8c.txt -> ${P}-josefsson-54265e8c.txt
	https://members.hellug.gr/nmav/pgpkeys.asc -> ${P}-nmav-pgpkeys.asc
	https://josefsson.org/key.txt -> ${P}-josefsson-key.txt
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libtasn1.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
