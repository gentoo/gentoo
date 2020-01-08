# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER=3.0

inherit autotools eutils wxwidgets

DESCRIPTION="Chemical 3D graphics program with GAMESS input builder"
HOMEPAGE="http://www.scl.ameslab.gov/MacMolPlt/"
SRC_URI="https://wxmacmolplt.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/glew:0=
	media-libs/mesa[X(+)]
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	need-wxwidgets unicode
	epatch "${FILESDIR}"/${P}-glew.patch
	sed \
		-e "/^dist_doc_DATA/d" \
		-i Makefile.am || die "Failed to disable installation of LICENSE file"
	eautoreconf
}

src_configure() {
	econf \
		--with-glew \
		--without-ming
}

src_install() {
	default
	doicon resources/${PN}.png
	make_desktop_entry ${PN} wxMacMolPlt ${PN} "Science;DataVisualization;"
}
