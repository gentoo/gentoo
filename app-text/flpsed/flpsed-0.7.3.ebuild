# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="Pseudo PostScript editor"
HOMEPAGE="https://flpsed.org/flpsed.html"
SRC_URI="https://flpsed.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	>=x11-libs/fltk-1.3.0:1
	app-text/ghostscript-gpl[X]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.7.2-desktop.patch )

src_install() {
	default

	doicon ${PN}.png
	doicon -s scalable ${PN}.svg
	domenu ${PN}.desktop
}
