# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg

DESCRIPTION="Graphical map editor for games using the DOOM engine"
HOMEPAGE="https://eureka-editor.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}-editor/Eureka/${PV%[a-z]}/${P}-source.tar.gz"
S="${WORKDIR}/${P}-source"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+opengl"

DEPEND="
	sys-libs/zlib
	x11-libs/fltk:1[opengl?]
	opengl? (
		media-libs/glu
		virtual/opengl
	)
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-Makefile.patch
)

DOCS=(
	AUTHORS.txt
	CHANGES.txt
	README.txt
	TODO.txt
)

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		OPENGL="$(usex opengl 1 0)"
}

src_install() {
	emake install PREFIX="${ED}/usr"
	einstalldocs

	doicon -s 32 misc/${PN}.xpm
	domenu misc/${PN}.desktop
}
