# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign notqmail releases"
HOMEPAGE="https://notqmail.org"
SRC_URI="
	https://der-dakon.net/eike-69b9fc4e-minimal.asc
		-> 9A6150DEAB029ADDF4D735E35CA4893E69B9FC4E.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - notqmail.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
