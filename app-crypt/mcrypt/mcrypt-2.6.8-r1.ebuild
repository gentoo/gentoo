# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mcrypt/mcrypt-2.6.8-r1.ebuild,v 1.6 2012/02/18 08:34:38 radhermit Exp $

EAPI="2"

inherit eutils

DESCRIPTION="replacement of the old unix crypt(1)"
HOMEPAGE="http://mcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mcrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-macos"
IUSE="nls"

DEPEND=">=dev-libs/libmcrypt-2.5.8
	>=app-crypt/mhash-0.9.9
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.6.7-qa.patch"
	epatch "${FILESDIR}/${P}-stdlib.h.patch"
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README THANKS TODO
}
