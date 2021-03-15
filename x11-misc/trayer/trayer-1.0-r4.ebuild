# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Lightweight GTK+ based systray for UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/fvwm-crystal/"
SRC_URI="https://sourceforge.net/projects/fvwm-crystal/files/${PN}/${PV}/${P}.tar.gz/download -> ${P}-sourceforge.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"

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
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	tc-export PKG_CONFIG

	emake "CC=$(tc-getCC)" CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}" -C systray
	emake "CC=$(tc-getCC)" CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}"
}

src_install() {
	dobin trayer
	doman "${FILESDIR}"/trayer.1
	einstalldocs
}
