# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/iax/iax-0.2.2.ebuild,v 1.9 2010/10/28 14:28:14 ssuominen Exp $

IUSE=""

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="http://www.digium.com/"
LICENSE="LGPL-2"
DEPEND=""
RDEPEND=""
SLOT="0"
SRC_URI="http://www.digium.com/pub/libiax/${P}.tar.gz"

D_PREFIX=/usr

KEYWORDS="x86 ppc"

src_compile() {
	./configure --prefix=${D_PREFIX} --enable-autoupdate

	export UCFLAGS="${CFLAGS}"

	emake || die
}

src_install () {
	make prefix="${D}"/${D_PREFIX} install
	dodoc NEWS AUTHORS README
}
