# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# XXX: When this expires next after 20250325, there should be a static
# key location for us to pull from (see https://github.com/gentoo/gentoo/pull/41230).
DESCRIPTION="OpenPGP keys used to sign lighttpd"
HOMEPAGE="https://www.lighttpd.net/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - lighttpd.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
