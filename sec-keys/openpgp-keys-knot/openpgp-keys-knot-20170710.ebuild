# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the Knot DNS developers"
HOMEPAGE="https://www.knot-dns.cz/download/"
SRC_URI="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x742fa4e95829b6c5eac6b85710bb7af6febbd6ab -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/${P}.asc knot.asc
}
