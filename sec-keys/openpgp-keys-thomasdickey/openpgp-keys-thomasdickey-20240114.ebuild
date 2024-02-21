# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Thomas Dickey"
HOMEPAGE="https://invisible-island.net/public/public.html"
# Expired, so we get the refreshed one from keyservers
#SRC_URI="https://invisible-island.net/public/dickey@invisible-island.net-rsa3072.asc -> ${P}-dickey@invisible-island.net-rsa3072.asc"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - thomasdickey.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
