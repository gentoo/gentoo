# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Bandwidth limiting pipe"
HOMEPAGE="http://klicman.org/throttle/"
SRC_URI="http://klicman.org/throttle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~ppc-macos ~x86-macos"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README ChangeLog
}
