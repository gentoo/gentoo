# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION="implementation of the BitTorrent core protocols in C"
HOMEPAGE="http://libbt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="dev-libs/openssl
	net-misc/curl
	>=sys-apps/util-linux-2.16.2
	!x11-wm/blackbox"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch #248034
	epatch "${FILESDIR}"/${PV}-btlist.patch # 152489
	sed -i -e '/CFLAGS/s|:=|+=|' src/Makefile.in || die
	# fix force as-needed. Bug #315213
	sed -i -e "/^LIBS/s:-lm:& -lcrypto:" src/Makefile.in || die
	eautoreconf
}

src_install() {
	dobin src/btlist src/btget src/btcheck || die
	doman man/*
	insinto /usr/include/libbt
	doins include/*
	dolib src/libbt.a
	dodoc CHANGELOG CREDITS README docs/*
}
