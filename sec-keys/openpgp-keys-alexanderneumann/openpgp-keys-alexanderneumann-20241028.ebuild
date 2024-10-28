# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Alexander Neumann"
HOMEPAGE="https://github.com/fd0"
SRC_URI="https://restic.net/gpg-key-alex.asc -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - alexanderneumann.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
