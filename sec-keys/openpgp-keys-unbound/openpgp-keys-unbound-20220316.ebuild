# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by unbound"
HOMEPAGE="https://unbound.net/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/EDFAA3F2CA4E6EB05681AF8E9F6F1C2D7E045F8D
		-> unbound-EDFAA3F2CA4E6EB05681AF8E9F6F1C2D7E045F8D.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - unbound.net.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
