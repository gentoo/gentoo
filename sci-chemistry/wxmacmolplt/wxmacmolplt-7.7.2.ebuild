# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit autotools desktop toolchain-funcs wxwidgets

DESCRIPTION="Chemical 3D graphics program with GAMESS input builder"
HOMEPAGE="http://brettbode.github.io/wxmacmolplt/"
SRC_URI="https://github.com/brettbode/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/glew:0=
	media-libs/mesa[X(+)]
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed \
		-e "/^dist_doc_DATA/d" \
		-i Makefile.am || die "Failed to disable installation of LICENSE file"
	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG

	setup-wxwidgets unicode
	econf \
		--with-glew \
		--without-ming
}

src_install() {
	default

	doicon resources/${PN}.png
	make_desktop_entry ${PN} wxMacMolPlt ${PN} "Science;DataVisualization;"
}
