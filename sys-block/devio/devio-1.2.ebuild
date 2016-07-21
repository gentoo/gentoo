# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="correctly read (or write) a region of a block device"
HOMEPAGE="http://devio.sourceforge.net/"
SRC_URI="mirror://sourceforge/devio/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm x86"
IUSE=""

DEPEND=""

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
