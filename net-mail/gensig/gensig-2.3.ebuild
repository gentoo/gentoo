# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gensig/gensig-2.3.ebuild,v 1.6 2009/09/23 19:06:33 patrick Exp $

DESCRIPTION="Random ~/.signature generator"
HOMEPAGE="http://www.geekthing.com/~robf/gensig/ChangeLog"
SRC_URI="http://www.geekthing.com/~robf/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_install () {
	make DESTDIR=${D} install || die
}
