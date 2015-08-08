# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit autotools eutils

DESCRIPTION="Secure file wiping utility based on Peter Gutman's patterns"
HOMEPAGE="http://wipe.sourceforge.net/"
SRC_URI="mirror://sourceforge/wipe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin wipe || die
	doman wipe.1 || die
	dodoc CHANGES README TODO TESTING || die
}

pkg_postinst() {
	elog "Note that wipe is useless on journaling filesystems,"
	elog "such as reiserfs, XFS, or ext3."
	elog "See documentation for more info."
}
