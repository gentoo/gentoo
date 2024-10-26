# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Andre Simon"
HOMEPAGE="http://andre-simon.de/zip/download.php#gpgsig"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xb8c55574187f49180edc763750fe0279d805a7c7
		-> B8C55574187F49180EDC763750FE0279D805A7C7.v2.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - andresimon.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
