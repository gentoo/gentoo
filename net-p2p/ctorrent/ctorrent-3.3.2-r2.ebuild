# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

MY_P="${PN}-dnh${PV}"

DESCRIPTION="Enhanced CTorrent is a BitTorrent console client written in C and C++"
HOMEPAGE="http://www.rahul.net/dholmes/ctorrent/"
SRC_URI="mirror://sourceforge/dtorrent/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND="dev-libs/openssl"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-CVE-2009-1759.patch
	epatch "${FILESDIR}"/${P}-negative-ints.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README-DNH.TXT README NEWS
}
