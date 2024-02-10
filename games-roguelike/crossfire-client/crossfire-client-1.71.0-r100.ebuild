# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit autotools desktop lua-single toolchain-funcs xdg-utils

DESCRIPTION="Client for the nethack-style but more in the line of UO"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua opengl sdl sound"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	lua? ( ${LUA_DEPS} )
	media-libs/libpng:0
	net-misc/curl
	opengl? ( virtual/opengl
		media-libs/freeglut )
	sdl? ( media-libs/libsdl[video]
		media-libs/sdl-image[png] )
	sound? ( media-libs/sdl-mixer[vorbis] )
	sys-libs/zlib
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -ri -e '/^.TH/s:$: 6:' $(find . -name "*man") || die
	# Since we have to rewrite this anyway, dispense with the wrapper
	# and point configure directly at the implementation of choice.
	sed -i -e "s/lua-5.1/${ELUA}/" configure.ac || die
	eautoreconf
}

src_configure() {
	# bugs in configure script so we cant use $(use_enable ...)
	local myconf

	use lua    && myconf="${myconf} --enable-lua"
	use sdl    || myconf="${myconf} --disable-sdl"
	use opengl || myconf="${myconf} --disable-opengl"
	use sound  || myconf="${myconf} --disable-sound"

	econf ${myconf}
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
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
