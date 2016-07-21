# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="system for dynamic feedback of server loads in a Linux Virtual Server (LVS)-based cluster"
HOMEPAGE="http://ozlabs.org/~jk/projects/feedbackd/"
SRC_URI="mirror://sourceforge/feedbackd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-libs/libxml2
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	econf \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-xml-config=/usr/bin/xml2-config \
		--with-perl=/usr/bin/perl \
		|| die "bad ./configure"

	emake || die
}

src_install() {
	#make DESTDIR=${D} install || die
	einstall || die
	dodoc ChangeLog NEWS README
}
