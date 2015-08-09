# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="http://stosberg.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc64 sparc x86 ~x86-macos"
IUSE=""

RDEPEND="
	!app-office/unoconv
	sys-libs/zlib
	virtual/libiconv
"
DEPEND="${RDEPEND}
	sys-apps/groff
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-darwin_iconv.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
	doman odt2txt.1
}
