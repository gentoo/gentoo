# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Variations on Rockdodger: Dodge the rocks until you die"
HOMEPAGE="https://sametwice.com/vor"
SRC_URI="https://jasonwoof.com/downloads/vor/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/bin

	default

	newicon data/icon.png ${PN}.png
	make_desktop_entry ${PN} VoR
}
