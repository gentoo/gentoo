# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Alex Barton"
HOMEPAGE="https://github.com/alexbarton https://keybase.io/alexbarton"
SRC_URI="https://keybase.io/alexbarton/pgp_keys.asc?fingerprint=f5b9f52ed90920d2520376a2c24a0f637e364856 -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - alexbarton.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
