# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the Knot Resolver developers"
HOMEPAGE="https://www.knot-resolver.cz/download/"
SRC_URI="https://secure.nic.cz/files/knot-resolver/kresd-keyblock.asc -> knot-resolver.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}"/knot-resolver.gpg
}
