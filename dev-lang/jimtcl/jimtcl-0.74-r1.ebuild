# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib

DESCRIPTION="Small footprint implementation of Tcl programming language"
HOMEPAGE="http://jim.tcl.tk"
SRC_URI="https://github.com/msteveb/jimtcl/zipball/${PV} -> ${P}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~s390 ~sh ~x86"
IUSE="doc static-libs"
DEPEND="doc? ( app-text/asciidoc )
	app-arch/unzip"

GIT_HASH="9a3562c"
S="${WORKDIR}"/msteveb-${PN}-${GIT_HASH}

src_configure() {
	! use static-libs && myconf=--with-jim-shared
	econf ${myconf}
}

src_compile() {
	emake all
	use doc && emake docs
}

src_install() {
	dobin jimsh
	use static-libs && {
		dolib.a libjim.a
	} || {
		dolib.so libjim.so.${PV}
		dosym /usr/$(get_libdir)/libjim.so.${PV} \
			/usr/$(get_libdir)/libjim.so
	}
	insinto /usr/include
	doins jim.h jimautoconf.h jim-subcmd.h jim-signal.h
	doins jim-win32compat.h jim-eventloop.h jim-config.h
	dodoc AUTHORS README TODO
	use doc && dohtml Tcl.html
}
