# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Pseudo PostScript editor"
HOMEPAGE="http://flpsed.org/flpsed.html"
SRC_URI="http://flpsed.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	>=x11-libs/fltk-1.3.0:1
	app-text/ghostscript-gpl[X]"

DEPEND="${RDEPEND}"
