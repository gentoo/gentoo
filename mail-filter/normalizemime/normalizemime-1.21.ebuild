# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Helper program to normalize MIME encoded messages"
HOMEPAGE="http://hyvatti.iki.fi/~jaakko/spam/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.cc"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_unpack() {
	cp "${DISTDIR}"/${P}.cc "${WORKDIR}"/${PN}.cc || die
}

src_compile() {
	tc-export CC
	emake normalizemime
}

src_install() {
	dobin normalizemime
}
