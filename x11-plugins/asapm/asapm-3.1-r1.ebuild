# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools epatch toolchain-funcs

DESCRIPTION="APM monitor for AfterStep"
HOMEPAGE="http://tigr.net/afterstep/applets/"
SRC_URI="http://www.tigr.net/afterstep/download/asapm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{ldflags,include,autoconf}.patch
	cp autoconf/configure.in . || die
	AT_M4DIR=autoconf eautoconf
	tc-export CC
}

src_install() {
	dobin asapm
	newman asapm.man asapm.1
	dodoc CHANGES README TODO NOTES
}
