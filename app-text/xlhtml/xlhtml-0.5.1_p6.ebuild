# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_PV=${PV/_p*/}
DEB_PR=${PV/*_p/}

DESCRIPTION="Convert MS Excel and Powerpoint files to HTML"
HOMEPAGE="http://chicago.sourceforge.net/xlhtml/ http://packages.debian.org/etch/xlhtml/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	ecvs_clean
	epatch "${WORKDIR}"/${PN}_${MY_PV}-${DEB_PR}.diff

	mv configure.{in,ac} || die

	eautoreconf
}

src_install() {
	default

	docinto cole
	dodoc cole/{AUTHORS,COPYING,NEWS,ChangeLog,THANKS,TODO}

	docinto ppthtml
	dodoc ppthtml/{ChangeLog,README,THANKS}

	docinto xlhtml
	dodoc -r xlhtml/{ChangeLog,README,THANKS,TODO,contrib}
}
