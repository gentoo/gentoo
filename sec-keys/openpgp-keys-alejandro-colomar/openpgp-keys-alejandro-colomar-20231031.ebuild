# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Alejandro Colomar"
HOMEPAGE="https://github.com/alejandro-colomar"
SRC_URI="https://github.com/alejandro-colomar.gpg -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - alejandro-colomar.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
