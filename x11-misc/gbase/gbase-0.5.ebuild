# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="a convert program for decimal, hexadecimal, octal and binary values"
HOMEPAGE="http://www.fluxcode.net"
SRC_URI="http://www.fluxcode.net/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtk.patch
}

src_compile() {
	tc-export CC
	emake
}

src_test() { :; } #424671

src_install() {
	dobin ${PN}
	dodoc README
}
