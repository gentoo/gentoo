# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtirpc/libtirpc-0.1.10.ebuild,v 1.2 2009/02/01 12:13:36 maekke Exp $

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="http://libtirpc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kerberos"

DEPEND="kerberos? ( net-libs/libgssglue )"

src_compile() {
	econf $(use_enable kerberos gss) || die
	emake || die
}

src_install() {
	dodir /etc
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
