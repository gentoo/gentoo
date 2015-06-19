# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mtree/mtree-1.0.1.ebuild,v 1.1 2013/06/15 10:14:32 radhermit Exp $

EAPI=5

inherit autotools

DESCRIPTION="Directory hierarchy mapping tool from FreeBSD"
HOMEPAGE="http://code.google.com/p/mtree-port/"
SRC_URI="http://mtree-port.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# don't install unneeded docs
	sed -i '/doc_DATA=/d' Makefile.am || die
	eautoreconf
}

src_install() {
	default

	# avoid conflict with app-arch/libarchive
	rm "${ED}usr/share/man/man5/mtree.5"
}
