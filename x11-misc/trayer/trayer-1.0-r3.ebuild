# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Lightweight GTK+ based systray for UNIX desktop"
HOMEPAGE="http://home.gna.org/fvwm-crystal/"
SRC_URI="http://download.gna.org/fvwm-crystal/trayer/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-dont-include-gdk-pixbuf-xlib.patch
	"${FILESDIR}"/${P}-dont-include-libXmu.patch
	"${FILESDIR}"/${P}-as-needed-and-pre-stripped.patch
)

src_compile() {
	tc-export PKG_CONFIG

	emake -j1 CC=$(tc-getCC) CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}"
}

src_install() {
	dobin trayer
	doman trayer.1
	einstalldocs
}
