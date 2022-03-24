# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign midipix releases"
HOMEPAGE="https://midipix.org/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-6482133FE45A8A91EEB0733716997AE880F70A46.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=(
		${P}-6482133FE45A8A91EEB0733716997AE880F70A46.asc
	)

	insinto /usr/share/openpgp-keys
	newins - midipix.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
