# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

MY_PN="LUIse"

DESCRIPTION="Programming interface for the Wallbraun LCD-USB-Interface"
HOMEPAGE="http://wallbraun-electronics.de/downloadssite/"
SRC_URI="http://www.wallbraun-electronics.de/downloads/${MY_PN}_${PV}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="doc examples"

DEPEND="=virtual/libusb-0*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}_${PV}"
src_install() {
	if use x86 ; then
		insinto /usr/include
		doins 32bit/luise.h
		dolib.so 32bit/libluise.so.0.1.1
	fi
	if use amd64 ; then
		insinto /usr/include
		doins 64bit/luise.h
		newlib.so 64bit/libluise_64.so.0.1.1 libluise.so.0.1.1
	fi
	dosym /usr/$(get_libdir)/libluise.so{.0.1.1,}

	newdoc doc/readme README
	use doc && dodoc doc/docu_luise011_Linux.pdf
	if use examples ; then
		docinto examples
		dodoc samples/luise-test/*
	fi
}
