# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Brian C. Lane"
HOMEPAGE="https://www.brianlane.com/about-brian-c-lane/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/B4C6B451E4FA8B4232CA191E117E8C168EFE3A7F
		-> B4C6B451E4FA8B4232CA191E117E8C168EFE3A7F.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - bcl.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
