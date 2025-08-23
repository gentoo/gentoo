# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by GNU wget"
HOMEPAGE="https://savannah.gnu.org/projects/wget/"
# Expired on savannah
#SRC_URI="https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=wget&download=1 -> ${P}.asc"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-7845120B07CBD8D6ECE5FF2B2A1743EDA91A35B6.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - wget.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
