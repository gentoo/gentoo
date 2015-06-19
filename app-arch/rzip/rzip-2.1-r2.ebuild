# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rzip/rzip-2.1-r2.ebuild,v 1.6 2012/05/23 14:41:02 jer Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Compression program for large files"
HOMEPAGE="http://rzip.samba.org"
SRC_URI="http://rzip.samba.org/ftp/rzip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~ppc64 ~sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-arch/bzip2"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1-darwin.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}

pkg_postinst() {
	ewarn "Warning: Gentoo shipped a broken rzip for quite some time. During"
	ewarn "compression of large files it didn't set the right file size, so"
	ewarn "if you have any reason to believe that your archive was compressed "
	ewarn "with an old Gentoo rzip, please refer to "
	ewarn "     http://bugs.gentoo.org/show_bug.cgi?id=217552 "
	ewarn "for the rzip-handle-broken-archive.patch patch to rescue your"
	ewarn "data."
	ewarn
	ewarn "We apologize for the inconvenience."
}
