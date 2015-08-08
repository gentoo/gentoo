# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

MY_P=${P/o-a/oa}

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="http://ufoai.sourceforge.net/"
SRC_URI="mirror://sourceforge/ufoai/${MY_P}-source.tar.bz2
	mirror://sourceforge/ufoai/${MY_P}-data.tar
	http://mattn.ninex.info/1maps.pk3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug dedicated editor"

# Dependencies and more instructions can be found here:
# http://ufoai.ninex.info/wiki/index.php/Compile_for_Linux
DEPEND="!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/libsdl
		media-libs/sdl-image[jpeg,png]
		media-libs/sdl-ttf
		media-libs/sdl-mixer
		virtual/jpeg
		media-libs/libpng:0
		media-libs/libogg
		media-libs/libvorbis
		x11-proto/xf86vidmodeproto
	)
	net-misc/curl
	sys-devel/gettext
	sys-libs/zlib
	editor? (
		dev-libs/libxml2
		virtual/jpeg
		media-libs/openal
		x11-libs/gtkglext
		x11-libs/gtksourceview:2.0
	)"

S=${WORKDIR}/${MY_P}-source

src_prepare() {
	if has_version '>=sys-libs/zlib-1.2.5.1-r1' ; then
		sed -i -e '1i#define OF(x) x' src/common/ioapi.h || die
	fi

	# don't try to use the system mini-xml
	sed -i -e '/mxml/d' configure || die

	epatch \
		"${FILESDIR}"/${P}-mathlib.patch \
		"${FILESDIR}"/${P}-anon.patch \
		"${FILESDIR}"/${P}-locale.patch

	cp "${DISTDIR}"/1maps.pk3 "${WORKDIR}"/base/ || die
	mv "${WORKDIR}"/base/ "${S}"/ || die
}

src_configure() {
	# they are special and provide hand batched configure file
	local myconf="
		--disable-dependency-tracking
		$(use_enable !debug release)
		$(use_enable editor ufo2map)
		$(use_enable editor uforadiant)
		--enable-ufoded
		--bindir="${GAMES_BINDIR}"
		--libdir="$(games_get_libdir)"
		--datadir="${GAMES_DATADIR}/${PN/-}"
		--localedir="${EPREFIX}/usr/share/locale/"
		--prefix="${GAMES_PREFIX}"
	"
	echo "./configure ${myconf}"
	./configure ${myconf} || die
}

src_compile() {
	emake
	emake lang

	if use editor; then
		emake uforadiant
	fi
}

src_install() {
	newicon src/ports/linux/ufo.png ${PN}.png
	dobin ufoded
	make_desktop_entry ufoded "UFO: Alien Invasion Server" ${PN}
	if ! use dedicated; then
		dobin ufo
		make_desktop_entry ufo "UFO: Alien Invasion" ${PN}
	fi

	if use editor; then
		dobin ufo2map ufomodel
	fi

	# install data
	insinto "${GAMES_DATADIR}"/${PN/-}
	doins -r base
	rm -rf "${ED}/${GAMES_DATADIR}/${PN/-}/base/game.so"
	dogameslib base/game.so

	# move translations where they belong
	dodir "${GAMES_DATADIR_BASE}/locale"
	mv "${ED}/${GAMES_DATADIR}/${PN/-}/base/i18n/"* \
		"${ED}/${GAMES_DATADIR_BASE}/locale/" || die
	rm -rf "${ED}/${GAMES_DATADIR}/${PN/-}/base/i18n/" || die

	prepgamesdirs
}
