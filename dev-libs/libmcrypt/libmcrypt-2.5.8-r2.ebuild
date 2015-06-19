# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmcrypt/libmcrypt-2.5.8-r2.ebuild,v 1.10 2014/08/10 20:36:16 slyfox Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="libmcrypt is a library that provides uniform interface to access several encryption algorithms"
HOMEPAGE="http://mcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mcrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-rotate-mask.patch
	eautoreconf # need new libtool for interix (elibtoolize would suffice for freebsd)
}

src_install() {
	make install DESTDIR="${D}" || die "install failure"

	dodoc AUTHORS NEWS README THANKS TODO ChangeLog
	dodoc doc/README.* doc/example.c
	prepalldocs
}
