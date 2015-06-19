# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/o3read/o3read-0.0.4.ebuild,v 1.11 2012/07/01 11:21:09 jlec Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Converts OpenOffice formats to text or HTML"
HOMEPAGE="http://siag.nu/o3read/"
SRC_URI="http://siag.nu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RESTRICT=test

src_prepare() {
	sed \
		-e 's:-o:$(LDFLAGS) -o:g' \
		-e '/^CC/d' \
		-e '/^CFLAGS/g' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	dobin o3read o3totxt o3tohtml utf8tolatin1
	doman o3read.1 o3tohtml.1 o3totxt.1 utf8tolatin1.1
}
