# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools toolchain-funcs gnome2-utils games

DESCRIPTION="Client for the nethack-style but more in the line of UO"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="lua opengl sdl sound"

RDEPEND="
	sound? ( media-libs/sdl-mixer[vorbis] )
	opengl? ( virtual/opengl
		media-libs/freeglut )
	sdl? ( media-libs/libsdl[video]
		media-libs/sdl-image[png] )
	lua? ( dev-lang/lua:0= )
	x11-libs/gtk+:2
	net-misc/curl
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -ri -e '/^.TH/s:$: 6:' $(find . -name "*man") || die
	sed -i -e 's/lua-5.1/lua/' configure.ac || die
	eautoreconf
}

src_configure() {
	# bugs in configure script so we cant use $(use_enable ...)
	local myconf

	use lua    && myconf="${myconf} --enable-lua"
	use sdl    || myconf="${myconf} --disable-sdl"
	use opengl || myconf="${myconf} --disable-opengl"
	use sound  || myconf="${myconf} --disable-sound"

	egamesconf ${myconf}
}

src_compile() {
	# bug 139785
	if use sound ; then
		emake -C sound-src AR="$(tc-getAR)"
	fi
	emake AR="$(tc-getAR)"
}

src_install() {
	local s

	default
	domenu gtk-v2/crossfire-client.desktop
	for s in 16 32 48
	do
		newicon -s ${s} pixmaps/${s}x${s}.png ${PN}.png
	done
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
