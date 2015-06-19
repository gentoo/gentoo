# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/psftools/psftools-1.0.7.ebuild,v 1.1 2009/10/09 11:14:54 pva Exp $

DESCRIPTION="Utilities for manipulation of console fonts in PSF format"
HOMEPAGE="http://www.seasip.info/Unix/PSF/"
SRC_URI="http://www.seasip.info/Unix/PSF/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS TODO doc/*.txt
}
