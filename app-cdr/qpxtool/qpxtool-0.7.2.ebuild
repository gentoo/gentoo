# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/qpxtool/qpxtool-0.7.2.ebuild,v 1.2 2014/02/03 06:34:59 polynomial-c Exp $

EAPI=5
inherit eutils toolchain-funcs qt4-r2

DESCRIPTION="CD/DVD quality checking utilities"
HOMEPAGE="http://qpxtool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4
	media-libs/libpng"

DOCS="AUTHORS ChangeLog README SupportedDevices TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.0-locale-install-race.patch \
		"${FILESDIR}"/${PN}-0.7.0-libpng15.patch \
		"${FILESDIR}"/${PN}-0.7.2-libs.patch
}

src_configure() {
	tc-export CXX
	./configure --prefix=/usr || die
	cd gui || die
	mv -v Makefile{,.orig} || die "Backup Makefile for install"
	qt4-r2_src_configure
}

src_install() {
	mv -v gui/Makefile.orig gui/Makefile || die "Restore Makefile for install"
	dodir /usr/bin
	dohtml status.html
	qt4-r2_src_install
}
