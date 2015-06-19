# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tabler/tabler-2.ebuild,v 1.4 2008/12/20 19:12:29 maekke Exp $

DESCRIPTION="A utility to create text art tables from delimited input"
HOMEPAGE="http://sourceforge.net/projects/tabler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog README
}
