# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Identify color of a pixel on the screen by clicking on a pixel on the screen"
HOMEPAGE="https://www.muquit.com/muquit/software/grabc/grabc.html"
SRC_URI="https://www.muquit.com/muquit/software/${PN}/${PN}${PV}.tar.gz"
S="${WORKDIR}/${PN}${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin grabc
	einstalldocs
}
