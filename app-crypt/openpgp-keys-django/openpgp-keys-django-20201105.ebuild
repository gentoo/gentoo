# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign Django releases"
HOMEPAGE="https://www.djangoproject.com/download/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/FE5FB63876A1D718A8C67556E17DF5C82B4F9D00
		-> FE5FB63876A1D718A8C67556E17DF5C82B4F9D00.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - django.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
