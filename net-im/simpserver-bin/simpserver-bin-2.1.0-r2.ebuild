# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN=${PN/-bin/}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SimpServer for Unix: IM instant security transparent proxy"
SRC_URI="http://download.secway.com/public/products/simpserver/${MY_P}-linux-x86.tgz"
HOMEPAGE="http://www.secway.com/"
LICENSE="simpserver-test"

KEYWORDS="-* ~amd64 ~x86"
IUSE=""
SLOT="0"
S=${WORKDIR}/simp

RESTRICT="strip"

src_compile() {
	einfo "Binary distribution.  No compilation required."
}

src_install () {
	dodoc README VERSION doc/CONFIG doc/TODO

	exeinto /opt/bin
	doexe bin/${MY_PN}

	insinto /etc
	doins etc/simp.conf

	newinitd "${FILESDIR}/${MY_PN}".rc ${MY_PN}
}

pkg_postinst() {
	elog "Please edit the configuration file: /etc/simp.conf."
}
