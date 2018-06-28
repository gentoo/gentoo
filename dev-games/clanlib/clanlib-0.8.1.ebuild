# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic eutils

DESCRIPTION="multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://clanlib.org/download/releases-${PV:0:3}/ClanLib-${PV}.tgz"

LICENSE="ZLIB"
SLOT="0.8"
KEYWORDS="amd64 x86" #not big endian safe #82779
IUSE="doc ipv6 mikmod opengl sdl static-libs vorbis"

# opengl keyword does not drop the GL/GLU requirement.
# Autoconf files need to be fixed
RDEPEND="media-libs/libpng:0
	virtual/jpeg:0
	virtual/glu
	virtual/opengl
	sdl? (
		media-libs/libsdl[X]
		media-libs/sdl-gfx
	)
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXxf86vm
	media-libs/alsa-lib
	mikmod? ( media-libs/libmikmod )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/ClanLib-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ndebug.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-gcc6.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_configure() {
	#clanSound only controls mikmod/vorbis so there's
	# no need to pass --{en,dis}able-clanSound ...
	#clanDisplay only controls X, SDL, OpenGL plugins
	# so no need to pass --{en,dis}able-clanDisplay
	# also same reason why we don't have to use clanGUI
	econf \
		--enable-dyn \
		--enable-clanNetwork \
		--disable-dependency-tracking \
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
	DOCS="CODING_STYLE CREDITS NEWS PATCHES README* INSTALL.linux" \
		default
	if use doc ; then
		dodir /usr/share/doc/${PF}/html
		mv "${D}"/usr/share/doc/clanlib/* "${D}"/usr/share/doc/${PF}/html/ || die
		rm -rf "${D}"/usr/share/doc/clanlib
		cp -r Examples Resources "${D}"/usr/share/doc/${PF}/ || die
	fi
	prune_libtool_files
}
