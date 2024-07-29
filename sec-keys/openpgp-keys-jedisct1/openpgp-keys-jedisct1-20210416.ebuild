# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Frank Denis (jedisct1)"
HOMEPAGE="https://github.com/jedisct1"
SRC_URI="https://download.pureftpd.org/public_keys/jedi.gpg.asc -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - jedisct1.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
