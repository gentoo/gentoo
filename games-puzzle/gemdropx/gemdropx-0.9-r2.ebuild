# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A puzzle game where it's your job to clear the screen of gems"
HOMEPAGE="http://www.newbreedsoftware.com/gemdropx/"
SRC_URI="ftp://ftp.sonic.net/pub/users/nbs/unix/x/gemdropx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2.3-r1[joystick,video]
	>=media-libs/sdl-mixer-1.2.1[mod]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/^CC/d' \
		-e '/^CXX/d' \
		-e 's/CXX/CC/' \
		-e 's/-o/$(LDFLAGS) -o/' \
		Makefile || die

	find data/ -type d -name .xvpics -exec rm -rf \{\} +
}

src_compile() {
	emake \
		DATA_PREFIX="/usr/share/${PN}" \
		XTRA_FLAGS="${CFLAGS}"
}

src_install() {
	dobin gemdropx
	dodir "/usr/share/${PN}"
	cp -r data/* "${ED}/usr/share/${PN}/" || die
	dodoc AUTHORS.txt CHANGES.txt ICON.txt README.txt TODO.txt
	newicon data/images/gemdropx-icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Gem Drop X" /usr/share/pixmaps/${PN}.xpm
}
