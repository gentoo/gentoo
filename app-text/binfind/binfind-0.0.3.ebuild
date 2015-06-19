# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/binfind/binfind-0.0.3.ebuild,v 1.2 2014/08/06 07:09:31 patrick Exp $

DESCRIPTION="binfind searches files for a byte sequence specified on the command line"
HOMEPAGE="http://www.lith.at/binfind"
SRC_URI="http://www.lith.at/binfind/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README ChangeLog
}
