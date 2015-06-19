# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/bozohttpd/bozohttpd-20140708.ebuild,v 1.2 2014/12/12 09:43:28 ago Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="bozohttpd is a small and secure http server"
HOMEPAGE="http://www.eterna.com.au/bozohttpd/"
SRC_URI="http://www.eterna.com.au/bozohttpd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}
	virtual/logger"

src_prepare() {
	mv Makefile{.boot,}
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${CFLAGS}"
}

src_install() {
	dobin bozohttpd
	doman bozohttpd.8

	newconfd "${FILESDIR}"/${PN}.conffile   bozohttpd
	newinitd "${FILESDIR}"/${PN}.initscript bozohttpd
}
