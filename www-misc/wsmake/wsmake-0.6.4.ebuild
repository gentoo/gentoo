# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Website Pre-processor"
HOMEPAGE="http://www.wsmake.org/"
SRC_URI="http://ftp.wsmake.org/pub/wsmake6/stable/wsmake-0.6.4.tar.bz2"

KEYWORDS="x86"
LICENSE="GPL-2 Artistic"
SLOT="0"
IUSE=""

src_unpack () {
	unpack ${A} && cd "${S}"
	epatch "${FILESDIR}"/${P}-bv.diff
	epatch "${FILESDIR}"/${P}-gcc43.patch	# 251745
}

src_compile () {
	econf || die "econf failed"
	emake || die "emake failed"
	cd doc
	tar -cf examples.tar examples || die
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING ChangeLog* DEVELOPERS LICENSE NEWS README TODO
	cd doc
	dodoc manual.txt examples.tar
}
