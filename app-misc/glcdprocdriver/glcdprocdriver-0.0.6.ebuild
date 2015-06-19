# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glcdprocdriver/glcdprocdriver-0.0.6.ebuild,v 1.4 2013/05/20 08:37:41 ago Exp $

EAPI="5"

inherit multilib toolchain-funcs eutils

DESCRIPTION="Glue library for the glcdlib LCDproc driver based on GraphLCD"
HOMEPAGE="http://www.muresan.de/graphlcd/lcdproc/"
SRC_URI="http://www.muresan.de/graphlcd/lcdproc/${P}.tar.bz2"

KEYWORDS="amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=app-misc/graphlcd-base-0.1.3
	sys-libs/glibc"
RDEPEND=${DEPEND}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}"
}

src_install()
{
	emake DESTDIR="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" install
	dodoc AUTHORS README INSTALL TODO ChangeLog
	dosym usr/$(get_libdir)/libglcdprocdriver.so{,.1}
}
