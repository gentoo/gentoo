# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="a physics based 2-D racer inspired by Micro Machines"
HOMEPAGE="http://sourceforge.net/projects/toycars"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video,joystick]
	media-libs/sdl-image[png]
	x11-libs/fltk:1[opengl]
	>=media-libs/fmod-4.25.07-r1:1
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-gcc45.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	mv data/tracks/Corner/{c,C}orner.map
}

src_configure() {
	append-ldflags -L/opt/fmodex/api/lib
	egamesconf
}

src_install() {
	default
	local d f

	newicon toycars/celica-render.png ${PN}.png
	make_desktop_entry ${PN} "Toy Cars"

	for d in toycars toycars_track_editor toycars_vehicle_editor
	do
		for f in ChangeLog README TODO
		do
			if [[ -s $d/$f ]] ; then
				newdoc $d/$f $d.$f
			fi
		done
	done
	prepgamesdirs
}
