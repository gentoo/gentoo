# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="APM monitor for AfterStep"
HOMEPAGE="http://tigr.net/afterstep/applets/"
SRC_URI="http://www.tigr.net/afterstep/download/asapm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc -sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-autoconf.patch
)

src_prepare() {
	default

	tc-export CC

	cp autoconf/configure.in . || die
	mv configure.{in,ac} || die

	AT_M4DIR=autoconf eautoreconf
}

src_install() {
	dobin asapm
	newman asapm.man asapm.1
	dodoc CHANGES README TODO NOTES
}
