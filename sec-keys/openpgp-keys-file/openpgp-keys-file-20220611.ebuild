# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Christos Zoulas (to sign file releases)"
# See e.g. https://github.com/file/file#gpg-for-dummies
HOMEPAGE="https://www.darwinsys.com/file/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-BE04995BA8F90ED0C0C176C471112AB16CB33B3A.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - file.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
