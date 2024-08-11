# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by dealii"
HOMEPAGE="https://www.dealii.org/ https://github.com/dealii/dealii/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/1EE97BF66221FC3069B5CF90B5A4E06FBD3A97A3
		-> ${P}-1EE97BF66221FC3069B5CF90B5A4E06FBD3A97A3.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/3D0EAB10AE6243B4BA27CE03E31EE5662371CB21
		-> ${P}-3D0EAB10AE6243B4BA27CE03E31EE5662371CB21.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - dealii.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
