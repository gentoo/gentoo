# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Tetris clone written in OpenGL"
HOMEPAGE="http://fbg.sourceforge.net/"
SRC_URI="mirror://sourceforge/fbg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/physfs
	media-libs/libmikmod
	media-libs/libsdl[opengl,video]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-missing-return.patch
)

src_prepare() {
	default

	sed -e "/FBGDATADIR=/s|=.*|=\"${EPREFIX}/usr/share/${PN}\"|" \
		-e '/^datadir=/d' \
		-i configure || die
}

src_configure() {
	econf --disable-fbglaunch --without-x
}

src_install() {
	default

	newicon startfbg/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Falling Block Game"

	rm -r "${ED}"/usr/doc || die
}
