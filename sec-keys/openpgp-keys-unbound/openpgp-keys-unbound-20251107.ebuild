# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by unbound"
HOMEPAGE="https://unbound.net/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/948EB42322C5D00B79340F5DCFF3344D9087A490
		-> unbound-948EB42322C5D00B79340F5DCFF3344D9087A490-20251107.asc
"

S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - unbound.net.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
