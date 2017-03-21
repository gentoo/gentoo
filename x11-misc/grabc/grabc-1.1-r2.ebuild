# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Identify color of a pixel on the screen by clicking on a pixel on the screen"
HOMEPAGE="https://www.muquit.com/muquit/software/grabc/grabc.html"
SRC_URI="https://www.muquit.com/muquit/software/${PN}/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${PN}${PV}"
PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin grabc
	einstalldocs
}
