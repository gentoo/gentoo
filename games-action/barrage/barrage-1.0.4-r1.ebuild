# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils

DESCRIPTION="A violent point-and-click shooting game"
HOMEPAGE="http://lgames.sourceforge.net/Barrage/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2.4"
RDEPEND="${DEPEND}"

src_install() {
	default

	newicon barrage48.png ${PN}.png
	make_desktop_entry ${PN} Barrage
	rm "${ED%/}"/usr/share/applications/${PN}.desktop || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
