# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A ham radio callsign DXCC lookup utility"
HOMEPAGE="http://fkurz.net/ham/dxcc.html"
SRC_URI="http://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tk"

RDEPEND="dev-lang/perl
	tk? ( dev-perl/Tk )"

src_prepare() {
	epatch "${FILESDIR}/Makefile.patch"
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc README ChangeLog
}
