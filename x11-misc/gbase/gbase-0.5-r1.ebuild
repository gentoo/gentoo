# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="a convert program for decimal, hexadecimal, octal and binary values"
HOMEPAGE="http://www.fluxcode.net"
SRC_URI="http://www.fluxcode.net/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RESTRICT="test" #424671

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gtk.patch )

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin ${PN}
	einstalldocs
}
