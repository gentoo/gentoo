# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="yeahconsole turns an xterm or rxvt-unicode into a game-like console"
HOMEPAGE="http://phrat.de/yeahtools.html"
SRC_URI="http://phrat.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~riscv x86"

RDEPEND="x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-C99-decls.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

pkg_postinst() {
	elog "Do not forget to emerge an xterm compatible terminal emulator"
	elog "(perhaps x11-terms/xterm or x11-terms/rxvt-unicode), or"
	elog "${PN} will not work ;-)."
}
