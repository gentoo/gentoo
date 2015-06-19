# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/dxcc/dxcc-20080225-r1.ebuild,v 1.3 2014/12/28 10:07:59 ago Exp $

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
	tk? ( dev-perl/perl-tk )"

src_prepare() {
	epatch "${FILESDIR}/Makefile.patch"
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc README ChangeLog
}
