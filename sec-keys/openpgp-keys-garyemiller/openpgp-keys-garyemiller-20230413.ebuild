# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="OpenPGP key for Gary E. Miller"
HOMEPAGE="https://gpsd.io/"
SRC_URI="https://keys.openpgp.org/vks/v1/by-fingerprint/1256D5A74A01B8145593C41EADA54A78FC147EEE -> ${P}-garyemiller.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - garyemiller.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
