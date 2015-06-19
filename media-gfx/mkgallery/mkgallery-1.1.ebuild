# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/mkgallery/mkgallery-1.1.ebuild,v 1.12 2010/01/07 22:20:24 fauli Exp $

DESCRIPTION="Creates thumbnails and a HTML index file for a directory of jpg files"
HOMEPAGE="http://mkgallery.sourceforge.net/"
SRC_URI="http://mkgallery.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
SLOT="0"

DEPEND="media-gfx/imagemagick"
RDEPEND="$DEPEND
	sys-devel/bc"

src_install() {
	dobin mkgallery
	dodoc BUGS README THANKS TODO
}
