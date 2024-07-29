# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Morten Linderund"
HOMEPAGE="https://linderud.dev/about/"
SRC_URI="
		https://linderud.dev/gpg.asc ->
				C100346676634E80C940FB9E9C02FF419FECBE16.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

S="${WORKDIR}"

src_install() {
		local files=( ${A} )
		insinto /usr/share/openpgp-keys
		newins - foxboron.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
