# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Fly about 3D-formed file system"
HOMEPAGE="http://xcruiser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake"

src_compile() {
	xmkmf -a
	emake CC=$(tc-getCC) CDEBUGFLAGS="${CFLAGS}" LOCAL_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xcruiser
	dodoc CHANGES README README.jp TODO
	newman xcruiser.man xcruiser.1
}
