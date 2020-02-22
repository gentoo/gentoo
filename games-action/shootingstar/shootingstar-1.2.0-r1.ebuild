# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop gnome2-utils

# Note: currently segfaults on startup, but that's also in the previous ebuild
# See https://bugs.gentoo.org/607428

DESCRIPTION="A topdown shooter"
HOMEPAGE="http://linux.softpedia.com/get/GAMES-ENTERTAINMENT/Arcade/Shooting-Star-19754.shtml"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${PV}-gcc34.patch
	"${FILESDIR}"/${P}-gcc44.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newicon -s 128 data/textures/body1.png ${PN}.png
	make_desktop_entry ${PN} "Shooting Star"
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
