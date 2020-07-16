# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop gnome2-utils

DESCRIPTION="A 2D multiplayer arcade game resembling V-Wing"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/luola"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/stdlevels-6.0.tar.gz
	mirror://gentoo/nostalgia-1.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[X,sound,joystick,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-sound
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /usr/share/${PN}/levels
	doins "${WORKDIR}"/*.{lev,png}
	dodoc AUTHORS ChangeLog DATAFILE FAQ LEVELFILE README TODO \
		RELEASENOTES.txt ../README.Nostalgia
	newdoc ../README README.stdlevels
	doicon -s 64 luola.png
	make_desktop_entry luola Luola
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
