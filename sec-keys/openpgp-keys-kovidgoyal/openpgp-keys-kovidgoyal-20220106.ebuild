# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Kovid Goyal"
HOMEPAGE="https://calibre-ebook.com/signatures/"
SRC_URI="https://calibre-ebook.com/signatures/kovid.gpg -> kovidgoyal.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	doins "${DISTDIR}"/kovidgoyal.gpg
}
