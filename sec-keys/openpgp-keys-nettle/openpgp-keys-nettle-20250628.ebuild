# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Niels Möller (to sign nettle releases)"
HOMEPAGE="https://www.lysator.liu.se/~nisse/"
SRC_URI="http://www.lysator.liu.se/~nisse/archive/distribution-key.gpg -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - nettle.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
