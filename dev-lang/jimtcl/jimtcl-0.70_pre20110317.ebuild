# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/jimtcl/jimtcl-0.70_pre20110317.ebuild,v 1.2 2012/05/05 16:51:29 hwoarang Exp $

EAPI="2"

DESCRIPTION="Small footprint implementation of Tcl programming language"
HOMEPAGE="http://jim.berlios.de/"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	! use static-libs && myconf=--with-jim-shared
	econf ${myconf} \
		--with-jim-ext=nvp
}

src_compile() {
	emake all docs || die
}

src_install() {
	dobin jimsh || die "dobin failed"
	use static-libs && {
		dolib.a libjim.a || die "dolib failed"
	} || {
		dolib.so libjim.so || die "dolib failed"
	}
	insinto /usr/include
	doins jim.h jimautoconf.h jim-subcmd.h jim-nvp.h jim-signal.h
	doins jim-win32compat.h jim-eventloop.h jim-config.h
	dodoc AUTHORS README TODO || die "dodoc failed"
	dohtml Tcl.html || die "dohtml failed"
}
