# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Ole Tange"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=(
		"${FILESDIR}"/BE9CB49381DE3166A3BC66C12C6229E2FFFFFFF1.asc
	)

	insinto /usr/share/openpgp-keys
	newins - oletange.asc < <(cat "${files[@]}" || die)
}
