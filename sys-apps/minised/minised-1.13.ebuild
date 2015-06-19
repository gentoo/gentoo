# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/minised/minised-1.13.ebuild,v 1.2 2009/11/30 11:56:17 ssuominen Exp $

inherit toolchain-funcs

DESCRIPTION="a smaller, cheaper, faster SED implementation"
HOMEPAGE="http://www.exactcode.de/oss/minised/"
SRC_URI="http://dl.exactcode.de/oss/minised/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc BUGS README
}
