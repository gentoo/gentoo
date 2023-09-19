# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by GNU findutils"
HOMEPAGE="https://savannah.gnu.org/projects/findutils/"
SRC_URI="https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=findutils&download=1 -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - findutils.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
