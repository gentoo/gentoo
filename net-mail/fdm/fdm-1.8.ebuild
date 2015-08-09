# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs user

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="http://fdm.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="courierauth examples pcre"

DEPEND="dev-libs/openssl:0
	sys-libs/tdb
	courierauth? ( net-libs/courier-authlib )
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser _fdm
}

src_prepare() {
	rm Makefile || die
	sed -e '/^FDEBUG=/s:=.*:=:' \
		-e "/ifdef COURIER/aLIBS+=-L${EROOT}usr/$(get_libdir)/courier-authlib" \
		-e '/CPPFLAGS/s: -I/usr/local/include : :' \
		-i GNUmakefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" \
		COURIER=$(use courierauth && echo 1) \
		PCRE=$(use pcre && echo 1)
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr MANDIR=/usr/share/man install
	dodoc CHANGES README TODO MANUAL
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
