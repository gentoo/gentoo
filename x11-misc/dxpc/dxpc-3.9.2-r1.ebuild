# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dxpc/dxpc-3.9.2-r1.ebuild,v 1.3 2012/02/16 19:30:48 phajdan.jr Exp $

DESCRIPTION="Differential X Protocol Compressor"
HOMEPAGE="http://www.vigor.nu/dxpc/"
SRC_URI="http://www.vigor.nu/dxpc/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libXt
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_install () {
	emake prefix="${D}/usr" man1dir="${D}/usr/share/man/man1" install || die
	dodoc CHANGES README TODO
}
