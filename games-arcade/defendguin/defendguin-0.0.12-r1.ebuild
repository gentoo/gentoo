# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A clone of the arcade game Defender, but with a Linux theme"
HOMEPAGE="http://www.newbreedsoftware.com/defendguin/"
SRC_URI="ftp://ftp.tuxpaint.org/unix/x/${PN}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/sdl-mixer[mod]
	media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "s:\$(DATA_PREFIX):/usr/share/${PN}/:" \
		-e '/^CFLAGS=.*-O2/d' \
		-e '/^CFLAGS=/s:=:+= $(LDFLAGS) :' \
		Makefile \
		|| die
	rm -f data/images/*.sh
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r ./data/*

	newicon data/images/ufo/ufo0.bmp ${PN}.bmp
	make_desktop_entry ${PN} Defendguin /usr/share/pixmaps/${PN}.bmp

	doman src/${PN}.6
	dodoc docs/{AUTHORS,CHANGES,README,TODO}.txt
}
