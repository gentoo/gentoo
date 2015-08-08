# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Library and applications to access GSM mobile phones"
SRC_URI="http://www.pxh.de/fs/gsmlib/snapshots/${PN}-pre${PV%_pre*}-${PV#*_pre}.tar.gz"
HOMEPAGE="http://www.pxh.de/fs/gsmlib/"

IUSE=""
SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"

RESTRICT="test"

S="${WORKDIR}/${PN}-${PV%_pre*}"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P%_pre*}-include-gcc34-fix.patch"
	epatch "${FILESDIR}/${P%_pre*}-gcc41.patch"
	epatch "${FILESDIR}"/${P%_pre*}-gcc43.patch
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
