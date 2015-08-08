# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

MY_P=${P/_/}

DESCRIPTION="Console based speech recognition system"
HOMEPAGE="http://www.kiecza.net/daniel/linux"
SRC_URI="http://www.kiecza.net/daniel/linux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo-2.patch
	sed -i -e "s/install-data-am: install-data-local/install-data-am:/" Makefile.in
	# Handle documentation with dohtml instead.
	sed -i -e "s:SUBDIRS = docs:#SUBDIRS = docs:" cvoicecontrol/Makefile.in
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ README
	dohtml cvoicecontrol/docs/en/*.html
}
