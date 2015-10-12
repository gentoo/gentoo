# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="bozohttpd is a small and secure http server"
HOMEPAGE="http://www.eterna.com.au/bozohttpd/"
SRC_URI="http://www.eterna.com.au/bozohttpd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="libressl"

DEPEND="!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}
	virtual/logger"

src_prepare() {
	mv Makefile{.boot,} || die
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
