# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Andre Simon"
HOMEPAGE="http://www.andre-simon.de/zip/download.php#gpgsig"
# Mirrored from http://www.andre-simon.de/zip/andre_simon.pub but then refreshed
# as it'd expired.
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-B8C55574187F49180EDC763750FE0279D805A7C7.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=(
		${P}-B8C55574187F49180EDC763750FE0279D805A7C7.asc
	)

	insinto /usr/share/openpgp-keys
	newins - andresimon.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
