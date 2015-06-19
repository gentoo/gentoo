# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/webcpp/webcpp-0.8.4.ebuild,v 1.12 2009/10/12 20:29:39 ssuominen Exp $

inherit eutils

DESCRIPTION="converts source code into HTML using a customizable syntax highlight engine and colour schemes"
HOMEPAGE="http://webcpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/webcpp/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ppc sparc x86"
IUSE=""

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS CREDITS ChangeLog README TODO
	fperms a+x /usr/bin/webc++ /usr/bin/scs2scs2.pl
}
