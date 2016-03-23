# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
inherit eutils

DESCRIPTION="A really tiny cross-platform proxy servers set"
HOMEPAGE="http://www.3proxy.ru/"
SRC_URI="http://3proxy.ru/${PV}/${P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cp Makefile.Linux Makefile || die
	default
}

src_install() {
	local x

	cd src || die
	dobin 3proxy
	for x in proxy socks ftppr pop3p tcppm udppm mycrypt dighosts icqpr smtpp; do
		newbin ${x} ${PN}-${x}
		[[ -f "${S}"/man/${x}.8 ]] && newman "${S}"/man/${x}.8 ${PN}-${x}.8
	done
	cd ..

	doman man/3proxy*.[38]

	dodoc Readme
	docinto html
	dodoc -r doc/html/*
	docinto cfg
	dodoc -r cfg/*
}
