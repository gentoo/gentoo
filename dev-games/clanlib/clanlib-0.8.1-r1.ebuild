# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://clanlib.org/download/releases-${PV:0:3}/ClanLib-${PV}.tgz"
S="${WORKDIR}"/ClanLib-${PV}

LICENSE="ZLIB"
SLOT="0.8"
# Not big endian safe! #82779
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 mikmod opengl sdl static-libs vorbis"

# opengl keyword does not drop the GL/GLU requirement.
# Autoconf files need to be fixed
RDEPEND="
	media-libs/alsa-lib
	media-libs/libpng:0
	virtual/jpeg:0
	virtual/glu
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXxf86vm
	mikmod? ( media-libs/libmikmod )
	sdl? (
		media-libs/libsdl[X]
		media-libs/sdl-gfx
	)
	vorbis? ( media-libs/libvorbis )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}/${P}-ndebug.patch"
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-llvm.patch"
	"${FILESDIR}/${P}-libpng15.patch"
	"${FILESDIR}/${P}-docbuilder.patch"
)

DOCS=(
	CODING_STYLE CREDITS NEWS PATCHES
	README{,.anjuta,.distros,.kdevelop,.sdl,.upgrade} INSTALL.linux
)

src_prepare() {
	default
	# See #739358
	sed -i -e "s:libdir=\${exec_prefix}/lib:libdir=@libdir@:g" \
		pkgconfig/*.pc.in || die
}

src_configure() {
	# clanSound only controls mikmod/vorbis so there's
	# no need to pass --{en,dis}able-clanSound ...
	# clanDisplay only controls X, SDL, OpenGL plugins
	# so no need to pass --{en,dis}able-clanDisplay
	# also same reason why we don't have to use clanGUI
	econf \
		--enable-dyn \
		--enable-clanNetwork \
		$(use_enable x86 asm386) \
		$(use_enable doc docs) \
		$(use_enable opengl clanGL) \
		$(use_enable sdl clanSDL) \
		$(use_enable vorbis clanVorbis) \
		$(use_enable mikmod clanMikMod) \
		$(use_enable ipv6 getaddr) \
		$(use_enable static-libs static)
}

src_install() {
	default

	if use doc ; then
		dodir /usr/share/doc/${PF}/html
		mv "${D}"/usr/share/doc/clanlib/* "${D}"/usr/share/doc/${PF}/html/ || die
		rm -rf "${D}"/usr/share/doc/clanlib
		cp -r Examples Resources "${D}"/usr/share/doc/${PF}/ || die
	fi

	find "${ED}" -name '*.la' -delete || die
}
