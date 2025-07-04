# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by GNU gettext"
HOMEPAGE="https://savannah.gnu.org/projects/gettext/"
#SRC_URI="https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=gettext&download=1 -> ${P}.asc"
# https://www.haible.de/bruno/gpgkeys.html
SRC_URI="
	https://www.haible.de/bruno/gpgkey-1BBEAC08.asc -> ${P}-1BBEAC08.asc
	https://www.haible.de/bruno/gpgkey-7C6A406D.asc -> ${P}-7C6A406D.asc
	https://www.haible.de/bruno/gpgkey-2E4616C2.asc -> ${P}-2E4616C2.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - gettext.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
