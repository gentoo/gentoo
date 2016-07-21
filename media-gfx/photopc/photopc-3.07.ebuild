# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Utility to control digital cameras based on Sierra Imaging firmware"
HOMEPAGE="http://photopc.sourceforge.net"
SRC_URI="mirror://sourceforge/photopc/${P}.tar.gz"

LICENSE="photopc"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	dodoc README
	dobin photopc epinfo
	doman photopc.1 epinfo.1
}
