# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libbt/libbt-1.06.ebuild,v 1.2 2010/07/12 20:20:35 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="implementation of the BitTorrent core protocols in C"
HOMEPAGE="http://libbt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-libs/openssl
	net-misc/curl
	>=sys-apps/util-linux-2.16.2"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_install() {
	dobin src/bt{check,get,list} || die

	insinto /usr/include/libbt
	doins include/*.h || die
	newlib.a src/libbt.a libbt-static.a || die

	doman man/*.1
	dodoc CHANGELOG CREDITS README docs/*.txt
}
