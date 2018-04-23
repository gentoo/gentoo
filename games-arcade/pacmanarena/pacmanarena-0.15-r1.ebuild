# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="3D Pacman clone with a few surprises. Rockets, bombs and explosions abound"
HOMEPAGE="http://pacmanarena.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/pacman-arena-${PV}.tar.bz2
	mirror://sourceforge/${PN}/pacman-data-0.0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	virtual/glu
	media-libs/libsdl[sound]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/pacman"

src_unpack() {
	unpack pacman-arena-${PV}.tar.bz2
	cd "${S}"
	unpack pacman-data-0.0.zip
}

src_prepare() {
	default
	sed -i \
		-e "/^CFLAGS/ s:pacman:${PN}:" \
		-e '1i CC=@CC@' \
		Makefile.in || die
	sed -i \
		-e '/CFLAGS/s:-g::' \
		configure || die
	eapply "${FILESDIR}"/${P}-underlink.patch
	eautoreconf
}

src_install() {
	newbin pacman ${PN}
	insinto /usr/share/${PN}
	doins -r gfx sfx
	newicon gfx/pacman_arena1.tga ${PN}.tga
	make_desktop_entry ${PN} "Pacman Arena" /usr/share/pixmaps/${PN}.tga
	einstalldocs
}
