# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="d453c12bfacde783b7e985cdb4eb15c6db277f78"
DESCRIPTION="OpenPGP keys used by ICU"
HOMEPAGE="https://icu.unicode.org/download/verification"
# https://github.com/unicode-org/icu/blob/main/KEYS
SRC_URI="https://raw.githubusercontent.com/unicode-org/icu/${MY_COMMIT}/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - icu.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
