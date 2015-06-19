# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cvoicecontrol/cvoicecontrol-0.9_alpha.ebuild,v 1.18 2009/05/24 19:31:09 ssuominen Exp $

IUSE=""

inherit eutils

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux/"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"

KEYWORDS="amd64 ppc sparc x86"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gentoo.diff"

	#remove "docs" from SUBDIRS in Makefile.in
	#Makefile will try to install few html files directly under the /usr
	#much easier to do with dohtml
	cd "${S}"/cvoicecontrol/
	sed -i -e "s:SUBDIRS = docs:#SUBDIRS = docs:" Makefile.in

	cd "${S}"
	sed -i -e "s/install-data-am: install-data-local/install-data-am:/" Makefile.in
}

src_install () {
	make DESTDIR="${D}" install || die

	#install documentation
	dodoc AUTHORS BUGS ChangeLog FAQ README
	dohtml cvoicecontrol/docs/en/*.html
}
