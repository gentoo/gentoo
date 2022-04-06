# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Antonio Diaz Diaz"
HOMEPAGE="https://savannah.gnu.org/users/antonio"
SRC_URI="https://savannah.gnu.org/people/viewgpg.php?user_id=12809 -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - antoniodiazdiaz.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
