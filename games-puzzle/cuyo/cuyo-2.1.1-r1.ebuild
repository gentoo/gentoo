# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2-utils versionator

MY_P="${PN}-$(get_version_component_range 1).~-$(get_version_component_range 2-3)"
DESCRIPTION="highly addictive and remotely related to tetris"
HOMEPAGE="https://www.karimmi.de/cuyo/"
SRC_URI="https://savannah.nongnu.org/download/cuyo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+music"

DEPEND="sys-libs/zlib
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mod] )
	media-libs/sdl-image
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-gcc6.patch
	eautoreconf
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
