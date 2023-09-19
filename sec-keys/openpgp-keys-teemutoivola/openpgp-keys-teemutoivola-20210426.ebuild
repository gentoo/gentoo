# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Teemu Toivola"
HOMEPAGE="https://humdi.net/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-23EF1DD76E65248FB055201ADAFE84E63D140114.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=(
		${P}-23EF1DD76E65248FB055201ADAFE84E63D140114.asc
	)

	insinto /usr/share/openpgp-keys
	newins - teemutoivola.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
