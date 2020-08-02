# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="bozohttpd is a small and secure http server"
HOMEPAGE="http://www.eterna.com.au/bozohttpd/"
SRC_URI="http://www.eterna.com.au/bozohttpd/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl"

DEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )"
RDEPEND="${DEPEND}
	virtual/logger"

src_prepare() {
	default
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
