# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Baldur Karlsson"
HOMEPAGE="https://renderdoc.org/builds"
SRC_URI="https://renderdoc.org/baldurk-pubkey.asc -> baldurkarlsson.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}"/baldurkarlsson.gpg
}
