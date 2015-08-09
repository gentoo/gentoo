# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="performs full/incremental backups of local/remote filesystems onto CD-R(W)s"
HOMEPAGE="http://cdbkup.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdbkup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="virtual/cdrtools
	virtual/eject"
RDEPEND="${DEPEND}
	!app-misc/cdcat"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:doc/cdbkup:doc/${P}:" Makefile.in || die
}

src_compile() {
	econf --with-snardir=/etc/cdbkup --with-dumpgrp=users
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc COMPLIANCE ChangeLog README TODO
}
