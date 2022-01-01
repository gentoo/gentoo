# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools desktop flag-o-matic toolchain-funcs

DESCRIPTION="Rotating pieces puzzle game"
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/pipewalker/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libpng:=
	media-libs/libsdl[opengl,sound,video]
	virtual/opengl
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags sdl || die)
	default
}

src_install() {
	emake -C data DESTDIR="${D}" install
	dobin src/${PN}
	doicon extra/${PN}.xpm
	make_desktop_entry ${PN} PipeWalker
	einstalldocs
}
