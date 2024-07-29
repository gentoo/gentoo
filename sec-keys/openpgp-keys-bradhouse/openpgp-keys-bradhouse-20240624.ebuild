# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Brad House"
HOMEPAGE="https://bradhouse.dev/ https://github.com/c-ares/c-ares"
SRC_URI="
	https://github.com/bradh352.gpg -> ${P}.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - bradhouse.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
