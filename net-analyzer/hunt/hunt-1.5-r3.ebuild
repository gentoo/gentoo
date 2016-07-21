# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="tool for checking well known weaknesses in the TCP/IP protocol"
HOMEPAGE="http://lin.fsid.cvut.cz/~kra/index.html"
SRC_URI="http://lin.fsid.cvut.cz/~kra/hunt/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-exit.patch \
		"${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-log2.patch
}

src_compile() {
	append-cflags -std=gnu89
	emake CC=$(tc-getCC)
}

src_install() {
	dobin hunt
	doman man/hunt.1
	dodoc CHANGES README* TODO tpsetup/transproxy
}
