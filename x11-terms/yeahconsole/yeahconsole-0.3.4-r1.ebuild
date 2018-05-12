# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="yeahconsole turns an xterm or rxvt-unicode into a game-like console"
HOMEPAGE="http://phrat.de/yeahtools.html"
SRC_URI="http://phrat.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa x86"
RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-proto/xproto
"
PATCHES=(
	"${FILESDIR}"/${P}-make.patch
)

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dodir /usr/bin
	emake PREFIX="${D}"/usr install
	dodoc README
}

pkg_postinst() {
	elog "Do not forget to emerge an xterm compatible terminal emulator"
	elog "(perhaps x11-terms/xterm or x11-terms/rxvt-unicode), or"
	elog "${PN} will not work ;-)."
}
