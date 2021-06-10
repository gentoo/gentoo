# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign Botan releases"
HOMEPAGE="https://botan.randombit.net https://botan.randombit.net/pgpkey.txt"
SRC_URI="https://botan.randombit.net/pgpkey.txt -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - botan.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
