# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by the Tor project"
HOMEPAGE="https://www.torproject.org/"
SRC_URI="https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290 -> EF6E286DDA85EA2A4BA7DE684E2C6E8793298290.asc
	 https://keys.openpgp.org/vks/v1/by-fingerprint/7A02B3521DC75C542BA015456AFEE6D49E92B601 -> 7A02B3521DC75C542BA015456AFEE6D49E92B601.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - torproject.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
