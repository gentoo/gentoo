# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign libidn releases"
HOMEPAGE="https://www.gnu.org/software/libidn/"
# Simon Josefsson
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-simonjosefsson-0424D4EE81A0E3D119C6F835EDA21E94B565716F.asc"
# Tim Rühsen
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-timruehsen-99415CE1905D0E55A9F88026860B7FBB32F8119D.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - libidn.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
