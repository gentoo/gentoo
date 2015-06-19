# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-zh_CN/man-pages-zh_CN-1.5.ebuild,v 1.6 2015/03/21 10:15:55 jlec Exp $

EAPI=5

inherit eutils

DESCRIPTION="A somewhat comprehensive collection of Chinese Linux man pages"
HOMEPAGE="http://cmpp.linuxforum.net/"
SRC_URI="http://download.sf.linuxforum.net/cmpp/${P}.tar.gz"

LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/man"

src_prepare() {
	ecvs_clean
}

src_configure() { :; }

src_compile() {
	emake u8
}

src_install() {
	emake install-u8 DESTDIR="${ED}"/usr/share
	dodoc README* DOCS/*
}
