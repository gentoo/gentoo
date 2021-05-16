# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="The game Missile Command for Linux"
HOMEPAGE="http://missile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e '/^CC/d' \
		-e "s:\$(game_prefix)/\$(game_data):/usr/share/${PN}:" \
		-e "s/-O2/${CFLAGS}/" \
		-e 's/-lSDL_image $(SND_LIBS)/-lSDL_image -lm $(SND_LIBS)/g' \
		Makefile || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data/*
	newicon -s 48 icons/${PN}_icon_black.png ${PN}.png
	make_desktop_entry ${PN} "Missile Command"
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
