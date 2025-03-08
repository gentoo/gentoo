# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by dnkl to sign releases & commits"
HOMEPAGE="https://codeberg.org/dnkl"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/B19964FBBA09664CC81027ED5BBD4992C116573F
	-> B19964FBBA09664CC81027ED5BBD4992C116573F.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - dnkl.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
