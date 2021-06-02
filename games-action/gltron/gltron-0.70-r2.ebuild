# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="3d tron, just like the movie"
HOMEPAGE="http://gltron.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libmikmod
	media-libs/libpng:0
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-sound[vorbis,mikmod]
	media-libs/smpeg
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

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
