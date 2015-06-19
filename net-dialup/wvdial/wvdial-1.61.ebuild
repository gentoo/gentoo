# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/wvdial/wvdial-1.61.ebuild,v 1.3 2012/05/03 03:54:07 jdhore Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Excellent program to automatically configure PPP sessions"
HOMEPAGE="http://alumnit.ca/wiki/?WvDial"
SRC_URI="http://wvstreams.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

COMMON_DEPEND=">=net-libs/wvstreams-4.4"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	net-dialup/ppp"

src_prepare() {
	epatch "${FILESDIR}/${P}-destdir.patch"
	epatch "${FILESDIR}/${P}-as-needed.patch"
	epatch "${FILESDIR}/${P}-parallel-make.patch"
}

src_configure() {
	# Hand made configure...
	./configure || die
}

src_install() {
	emake "DESTDIR=${ED}" install || die "make install failed"
	dodoc CHANGES FAQ MENUS README TODO || die
}

pkg_postinst() {
	elog
	elog "Use wvdialconf to automagically generate a configuration file."
	elog
	elog "Users have to be member of the dialout AND the uucp group"
	elog "to use wvdial!"
	elog
}
