# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by GnuTLS"
HOMEPAGE="https://www.gnutls.org/download.html"
# Mirrored Dmitry's key b/c only on keyservers
SRC_URI="
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-dmitry.asc
	https://www.gnutls.org/pgpkey-tim.txt -> ${P}-tim.asc
	https://www.gnutls.org/pgpkey-ueno.txt -> ${P}-ueno.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - gnutls.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
