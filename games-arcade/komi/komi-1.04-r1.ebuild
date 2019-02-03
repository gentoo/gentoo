# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Komi the Space Frog - simple SDL game of collection"
HOMEPAGE="http://komi.sourceforge.net"
SRC_URI="mirror://sourceforge/komi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PV}-DESTDIR.patch \
		"${FILESDIR}"/${P}-install.patch
	sed -i \
		-e "/^BINPATH/s:=.*:=/usr/bin/:" \
		-e "/^DATAPATH/s:=.*:=/usr/share/${PN}/:" \
		-e '/^SDL_LIB/s:$: $(LDFLAGS):' \
		-e '/^SDL_LIB/s:--static-:--:' \
		Makefile \
		|| die "sed failed"
}

src_compile() {
	emake ECFLAGS="${CFLAGS}"
}

src_install() {
	default
	newicon komidata/sprites_komi.bmp ${PN}.bmp
	make_desktop_entry komi Komi /usr/share/pixmaps/${PN}.bmp
	doman komi.6
}
