# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_P="gl-117-${PV}-src"
DESCRIPTION="An action flight simulator"
HOMEPAGE="http://www.heptargon.de/gl-117/gl-117.html"
SRC_URI="mirror://sourceforge/gl-117/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	media-libs/freeglut
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-mixer[mod]
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-mode.patch
)

src_install() {
	DOCS="doc/gl-117.pdf AUTHORS ChangeLog FAQ NEWS README" \
		default
	newicon doc/src/falcon.jpg ${PN}.jpg
	make_desktop_entry gl-117 GL-117 /usr/share/pixmaps/${PN}.jpg
	doman doc/gl-117.6
}
