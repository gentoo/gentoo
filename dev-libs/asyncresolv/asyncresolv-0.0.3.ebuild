# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/asyncresolv/asyncresolv-0.0.3.ebuild,v 1.7 2009/03/09 20:16:45 halcy0n Exp $

DESCRIPTION="Asynchronous DNS query library written in C++"
HOMEPAGE="http://asyncresolv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"

IUSE=""
DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	sed -i -e 's/-Werror//' configure
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"

	dodoc AUTHORS COPYING* ChangeLog INSTALL README TODO
	dohtml doc/index.html
}
