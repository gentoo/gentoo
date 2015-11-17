# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic gnome2-utils

MY_P=${P/ufo-ai/ufoai}

# better than the default "/usr/games/ufo/"
MY_DATADIR="${EPREFIX}/usr/share/games/${PN/-}"

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufoai.sourceforge.net/"
SRC_URI="mirror://sourceforge/ufoai/${MY_P}-source.tar.bz2
	mirror://sourceforge/ufoai/${MY_P}-data.tar
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# "editor" USE flag disabled until someone gets it to work
# See http://ufoai.org/forum/index.php?topic=8978
IUSE="debug dedicated profile"

# Dependencies and more instructions can be found here:
# http://ufoai.ninex.info/wiki/index.php/Compile_for_Linux
DEPEND="!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libsdl2[joystick,opengl,sound,threads,video]
		media-libs/sdl2-image[jpeg,png]
		media-libs/sdl2-ttf
		media-libs/sdl2-mixer
		virtual/jpeg:62
		media-libs/libpng:0
		media-libs/libogg
		media-libs/libvorbis
		media-libs/libtheora
		x11-proto/xf86vidmodeproto
	)
	net-misc/curl
	sys-devel/gettext
	sys-libs/zlib
"
	# editor? (
	# 	dev-libs/libxml2
	# 	virtual/jpeg:62
	# 	media-libs/openal
	# 	x11-libs/gtkglext
	# 	x11-libs/gtksourceview:2.0
	# )
	# "

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}-source

pkg_setup() {
	if use profile; then
		ewarn "USE=\"profile\" is incompatible with the hardened profile's -pie flag."
	fi

	einfo "
	Note that the dedicated server (ufoded) is currently missing some
	map files and therefore might not start:
	http://ufoai.org/bugs/ufoalieninvasion/issues/5383

	Help to fix this is welcome!
"
	if use dedicated ; then
		ewarn "Only building dedicated server, which is known to still fail."
	fi
}

src_unpack() {
	unpack ${MY_P}-source.tar.bz2
	cd "${S}" || die
	unpack ${MY_P}-data.tar
}

src_configure() {
	# The configure script of UFO:AI is hand crafted and a bit special
	local MY_CONF=(
		--disable-cgame-campaign
		--disable-cgame-multiplayer
		--disable-cgame-skirmish
		--disable-memory
		--disable-testall
		--disable-ufomodel
		--disable-ufoslicer
		--enable-ufoded
		$(use_enable !debug release)
		# $(use_enable !dedicated game)
		--disable-uforadiant
		--disable-ufo2map
		# $(use_enable editor uforadiant)
		# $(use_enable editor ufo2map)
		--disable-paranoid
		$(use_enable profile profiling)
		--prefix="${EPREFIX}"/usr/
		--datadir="${MY_DATADIR}"
	)
	# econf does not work: "invalid option --build=x86_64-pc-linux-gnu"
	./configure ${MY_CONF[*]} || die
}

src_compile() {
	emake
	emake lang

	# if use editor; then
	# 	emake uforadiant
	# fi
}

src_install() {
	newicon -s 32 src/ports/linux/ufo.png ${PN}.png

	emake DESTDIR="${D}" install

	# Shell script wrappers are always created for ufo, ufoded and
	# uforadiant, delete them if we don't need them
	rm "${D}/usr/bin/uforadiant" || die
	# if !use editor; then
	# 	rm "${D}/usr/bin/uforadiant" || die
	# fi

	if use dedicated; then
		rm "${D}/usr/bin/ufo" || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
