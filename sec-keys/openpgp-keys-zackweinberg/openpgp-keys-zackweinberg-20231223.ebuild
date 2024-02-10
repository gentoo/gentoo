# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Zack Weinberg"
HOMEPAGE="https://www.owlfolio.org/about/ https://www.owlfolio.org/contact/"
# https://www.owlfolio.org/contact/
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/82F854F3CE73174B8B63174091FCC32B6769AA64
		-> ${P}-82F854F3CE73174B8B63174091FCC32B6769AA64.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - zackweinberg.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
