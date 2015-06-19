# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/cthumb/cthumb-4.2.ebuild,v 1.11 2014/08/10 21:13:54 slyfox Exp $

DESCRIPTION="Create a statical HTML Image gallery with captions for each image"

HOMEPAGE="http://cthumb.sourceforge.net"
SRC_URI="mirror://sourceforge/cthumb/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="dev-perl/URI
	dev-perl/HTML-Parser
	media-libs/netpbm"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
}

src_install () {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
}
