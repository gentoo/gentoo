# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs gnome2-utils games

DESCRIPTION="Client for the nethack-style but more in the line of UO"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="alsa lua oss sdl"

RDEPEND="alsa? ( media-libs/alsa-lib )
	virtual/opengl
	x11-libs/gtk+:2
	gnome-base/libglade
	sdl? ( media-libs/libsdl[video]
		media-libs/sdl-image )
	lua? ( dev-lang/lua )
	net-misc/curl
	media-libs/freeglut
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -ri -e '/^.TH/s:$: 6:' $(find . -name "*man") || die
}

src_configure() {
	# bugs in configure script so we cant use $(use_enable ...)
	local myconf

	use sdl || myconf="${myconf} --disable-sdl"
	use alsa || myconf="${myconf} --disable-alsa9 --disable-alsa"
	if ! use alsa && ! use oss ; then
		myconf="${myconf} --disable-sound"
	fi
	egamesconf ${myconf}
}

src_compile() {
	# bug 139785
	if use alsa || use oss ; then
		emake -j1 -C sound-src AR="$(tc-getAR)"
	fi
	emake AR="$(tc-getAR)"
}

src_install() {
	local s

	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
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
