# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/isapnptools/isapnptools-1.27.ebuild,v 1.4 2012/01/21 16:13:56 phajdan.jr Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Tools for configuring ISA PnP devices"
HOMEPAGE="http://www.roestock.demon.co.uk/isapnptools/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/hardware/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodir /sbin
	mv "${D}"/usr/sbin/isapnp "${D}"/sbin/ || die

	dodoc AUTHORS ChangeLog README NEWS
	docinto txt
	dodoc doc/README*  doc/*.txt test/*.txt
	dodoc etc/isapnp.*

	newinitd "${FILESDIR}"/isapnp.rc isapnp
}
