# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the Tor project"
HOMEPAGE="https://www.torproject.org/"
# see https://gitweb.torproject.org/tor.git/tree/README.md
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/1C1BC007A9F607AA8152C040BEA7B180B1491921
		-> tor-${PV}-1C1BC007A9F607AA8152C040BEA7B180B1491921.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36
		-> tor-${PV}-B74417EDDF22AC9F9E90F49142E86A2A11F48D36.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/2133BC600AB133E1D826D173FE43009C4607B1FB
		-> tor-${PV}-2133BC600AB133E1D826D173FE43009C4607B1FB.asc
"
# old keys
SRC_URI+="
	https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290
		-> tor-${PV}-EF6E286DDA85EA2A4BA7DE684E2C6E8793298290.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - torproject.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
