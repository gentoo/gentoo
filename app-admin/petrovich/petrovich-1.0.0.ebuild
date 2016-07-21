# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

S=${WORKDIR}/${PN}
DESCRIPTION="Filesystem Integrity Checker"
SRC_URI="mirror://sourceforge/petrovich/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/petrovich"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/perl-Digest-MD5"

src_unpack () {
	unpack ${A}
	cd "${WORKDIR}"
	epatch "${FILESDIR}"/${PF}-gentoo.diff
}

src_install() {
	dosbin petrovich.pl

	insinto /etc
	doins "${FILESDIR}"/petrovich.conf

	dodir /var/db/petrovich

	dohtml CHANGES.HTML LICENSE.HTML README.HTML TODO.HTML USAGE.HTML
}
