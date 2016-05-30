# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs user

DESCRIPTION="fetch, filter and deliver mail"
HOMEPAGE="https://github.com/nicm/fdm"
SRC_URI="https://github.com/nicm/fdm/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="courierauth examples libressl pcre"

DEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/tdb
	courierauth? ( net-libs/courier-authlib )
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser _fdm
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
