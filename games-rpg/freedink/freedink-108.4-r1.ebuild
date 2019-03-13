# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Dink Smallwood is an adventure/role-playing game, similar to Zelda (2D top view)"
HOMEPAGE="http://www.freedink.org/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-libs/fontconfig-2.4
	>=media-libs/libsdl-1.2[X,sound,joystick,video]
	>=media-libs/sdl-gfx-2.0
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2[midi,vorbis,wav]
	>=media-libs/sdl-ttf-2.0.9
"
RDEPEND="${DEPEND}
	games-rpg/freedink-data
"
DEPEND="${DEPEND}
	dev-libs/check
	virtual/pkgconfig
	sys-devel/gettext
"
PATCHES=(
	"${FILESDIR}"/${PN}-108.4-no-windres.patch
)

src_prepare() {
	default
	sed -i \
		-e 's#^datarootdir =.*$#datarootdir = /usr/share#' \
		share/Makefile.in || die
	# seems like the code is fragile (bug #559548)
	filter-flags
	replace-flags -O? -O0
}

src_configure() {
	econf \
		--disable-embedded-resources \
		--localedir="/usr/share/locale"
}
