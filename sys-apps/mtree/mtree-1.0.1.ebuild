# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Directory hierarchy mapping tool from FreeBSD"
HOMEPAGE="https://code.google.com/p/mtree-port/"
SRC_URI="https://mtree-port.googlecode.com/files/${P}.tar.gz"

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
