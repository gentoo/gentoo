# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

S="${WORKDIR}/${P}-001114"

DESCRIPTION="A simple fax program for single-user systems"
HOMEPAGE="http://www.cce.com/efax"
SRC_URI="http://www.cce.com/efax/download/${P}-001114.tar.gz
	mirror://debian/pool/main/e/efax/efax_0.9a-19.diff.gz"

KEYWORDS="amd64 ppc x86"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

src_prepare () {
	epatch "${WORKDIR}/${PN}_${PV}-19.diff"
	rm -f "${S}"/${P}/debian/patches/series "${S}"/${P}/debian/patches/00list
	EPATCH_FORCE="yes" epatch "${S}"/${P}/debian/patches/*

	epatch "${FILESDIR}/${P}-fax-command.patch" #327737

	# remove strip command as per bug #240932
	sed -i -e '/strip/d' Makefile
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install () {
	dobin efax efix fax
	doman efax.1 efix.1
	newman fax.1 efax-fax.1 # Don't collide with net-dialup/mgetty, bug #429808
	dodoc README
}
