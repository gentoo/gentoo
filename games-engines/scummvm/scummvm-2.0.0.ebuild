# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic gnome2-utils toolchain-funcs xdg-utils

DESCRIPTION="Reimplementation of the SCUMM game engine used in Lucasarts adventures"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="http://scummvm.org/frs/scummvm/${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1 BSD GPL-3-with-font-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd"
IUSE="aac alsa debug flac fluidsynth jpeg mpeg2 mp3 opengl png theora truetype unsupported vorbis zlib"
RESTRICT="test"  # it only looks like there's a test there #77507

RDEPEND=">=media-libs/libsdl2-2.0.0[sound,joystick,video]
	zlib? ( sys-libs/zlib )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0 )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	mp3? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	flac? ( media-libs/flac )
	opengl? ( virtual/opengl )
	truetype? ( media-libs/freetype:2 )
	fluidsynth? ( media-sound/fluidsynth )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	x86? ( dev-lang/nasm )"

S=${WORKDIR}/${P/_/}

src_prepare() {
	default

	# -g isn't needed for nasm here
	sed -i \
		-e '/NASMFLAGS/ s/-g//' \
		configure || die
	sed -i \
		-e '/INSTALL.*doc/d' \
		-e '/INSTALL.*\/pixmaps/d' \
		-e 's/-s //' \
		ports.mk || die
}

src_configure() {
	use x86 && append-ldflags -Wl,-z,noexecstack

	# NOT AN AUTOCONF SCRIPT SO DONT CALL ECONF
	SDL_CONFIG="sdl2-config" \
	./configure \
		--backend=sdl \
		--host=${CHOST} \
		--enable-verbose-build \
		--prefix=/usr \
		--libdir="/usr/$(get_libdir)" \
		--opengl-mode=$(usex opengl auto none) \
		$(use_enable aac faad) \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable !debug release-mode) \
		$(use_enable flac) \
		$(usex fluidsynth '' --disable-fluidsynth) \
		$(use_enable jpeg) \
		$(use_enable mp3 mad) \
		$(use_enable mpeg2) \
		$(use_enable png) \
		$(use_enable theora theoradec) \
		$(use_enable truetype freetype2) \
		$(usex unsupported --enable-all-engines '') \
		$(use_enable vorbis) \
		$(use_enable zlib) \
		$(use_enable x86 nasm) \
		${myconf} ${EXTRA_ECONF} || die
}

src_compile() {
	emake AR="$(tc-getAR) cru" RANLIB=$(tc-getRANLIB)
}

src_install() {
	default
	doicon -s scalable icons/scummvm.svg
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
