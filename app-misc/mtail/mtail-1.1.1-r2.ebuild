# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1-r2.ebuild,v 1.6 2012/12/02 06:13:06 radhermit Exp $

EAPI="3"

inherit eutils python

DESCRIPTION="Tail workalike, that performs output colourising"
HOMEPAGE="http://matt.immute.net/src/mtail/"
SRC_URI="http://matt.immute.net/src/mtail/mtail-${PV}.tgz
	http://matt.immute.net/src/mtail/mtailrc-syslog.sample"

LICENSE="HPND"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-remove-blanks.patch
	python_convert_shebangs -r 2 .
}

src_install() {
	dobin mtail || die
	dodoc CHANGES mtailrc.sample README "${DISTDIR}"/mtailrc-syslog.sample || die
}
