# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/supercat/supercat-0.5.5-r1.ebuild,v 1.5 2011/03/02 01:47:36 ranger Exp $

EAPI="3"

DESCRIPTION="A text file colorizer using powerful regular expressions"
HOMEPAGE="http://supercat.nosredna.net"
SRC_URI="http://supercat.nosredna.net/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

src_configure() {
	econf --with-system-directory="${EPREFIX}/etc/supercat"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"

	dodoc ChangeLog || die
}
