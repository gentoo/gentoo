# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="Variations on Rockdodger: Dodge the rocks until you die"
HOMEPAGE="https://jasonwoof.org/vor"
SRC_URI="https://jasonwoof.com/downloads/vor/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/bin
	DOCS="README* todo" default
	newicon -s 48 data/icon.png ${PN}.png
	make_desktop_entry ${PN} VoR
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
