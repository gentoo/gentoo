# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="3d tron, just like the movie"
HOMEPAGE="http://gltron.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	media-libs/libmikmod
	media-libs/libpng:0
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-sound[vorbis,mikmod]
	media-libs/smpeg
	virtual/opengl"

RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-debian.patch
	"${FILESDIR}"/${P}-gcc49.patch
	"${FILESDIR}"/${P}-prototypes.patch
)

src_prepare() {
	default
	sed -i \
		-e '/^gltron_LINK/s/$/ $(LDFLAGS)/' \
		Makefile.in || die
}

src_configure() {
	# warn/debug/profile just modify CFLAGS, they aren't
	# real options, so don't utilize USE flags here
	econf \
		--disable-warn \
		--disable-debug \
		--disable-profile
}

src_install() {
	default
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} GLtron
}
