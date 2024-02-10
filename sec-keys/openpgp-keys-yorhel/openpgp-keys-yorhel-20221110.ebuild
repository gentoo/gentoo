# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Yoran Heling"
HOMEPAGE="https://dev.yorhel.nl"
SRC_URI="https://yorhel.nl/key.asc -> ${P}-key.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - yoranheling.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
