# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Ole Tange"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=(
		"${FILESDIR}"/CDA01A4208C4F74506107E7BD1AB451688888888.asc
	)

	insinto /usr/share/openpgp-keys
	newins - oletange.asc < <(cat "${files[@]}" || die)
}
