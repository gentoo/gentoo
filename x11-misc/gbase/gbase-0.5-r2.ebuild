# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A convert program for decimal, hexadecimal, octal and binary values"
HOMEPAGE="http://www.fluxcode.net"
SRC_URI="http://www.fluxcode.net/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test" #424671

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gtk.patch )

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin gbase
	einstalldocs
}
