# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/turtlearena/turtlearena-0.6.1.ebuild,v 1.6 2014/05/15 16:46:38 ulm Exp $

EAPI=5

inherit eutils gnome2-utils games

MY_P=${PN/-/}-${PV}

DESCRIPTION="A turtle featuring free and open source third-person action game (ioq3 engine)"
HOMEPAGE="http://ztm.x10host.com/ta/index.htm"
SRC_URI="http://turtlearena.googlecode.com/files/${MY_P}-0-src.tar.bz2
	http://turtlearena.googlecode.com/files/${MY_P}-0.zip"

LICENSE="GPL-2+ CC-BY-SA-3.0 mplus-fonts lcc"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+curl debug dedicated mumble openal server theora voice vorbis"

RDEPEND="
	sys-libs/zlib[minizip]
	!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl[X,sound,joystick,opengl,video]
		virtual/jpeg:0
		virtual/opengl
		curl? ( net-misc/curl )
		openal? ( media-libs/openal )
		theora? ( media-libs/libtheora )
		voice? (
			media-libs/speex
			mumble? ( media-sound/mumble )
		)
		vorbis? ( media-libs/libvorbis )
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}-0-src

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-freetype.patch

	sed -i \
		-e 's:JPEG_LIB_VERSION < 80:JPEG_LIB_VERSION < 62:' \
		engine/code/renderer/tr_image_jpg.c || die #479822

	rm -r engine/code/{AL,libcurl,libogg,libspeex,libtheora,libvorbis,SDL12,zlib} \
		engine/code/freetype* engine/code/jpeg-* \
		engine/code/qcommon/unzip.{c,h} || die
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }
	nobuildit() { use $1 && echo 0 || echo 1 ; }

	myarch=$(usex amd64 "x86_64" "x86")
	emake -C engine \
		Q="" \
		ARCH=${myarch} \
		CROSS_COMPILING=0 \
		BUILD_GAME_QVM=0 \
		BUILD_GAME_SO=0 \
		BUILD_CLIENT=$(nobuildit dedicated) \
		BUILD_SERVER=$(usex dedicated "1" "$(buildit server)") \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/${PN}" \
		GENERATE_DEPENDENCIES=0 \
		OPTIMIZEVM="" \
		OPTIMIZE="" \
		DEBUG_CFLAGS="" \
		USE_MUMBLE=$(buildit mumble) \
		USE_VOIP=$(buildit voice) \
		USE_INTERNAL_SPEEX=0 \
		USE_INTERNAL_OGG=0 \
		USE_INTERNAL_ZLIB=0 \
		USE_INTERNAL_JPEG=0 \
		USE_INTERNAL_FREETYPE=0 \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_INTERNAL_VORBIS=0 \
		USE_CODEC_THEORA=$(buildit theora) \
		USE_OPENAL=$(buildit openal) \
		USE_OPENAL_DLOPEN=0 \
		USE_CURL=$(buildit curl) \
		USE_CURL_DLOPEN=0 \
		USE_LOCAL_HEADERS=0 \
		$(usex debug "debug" "release")
}

src_install() {
	dodoc engine/{ChangeLog,BUGS,TODO}
	use voice && dodoc engine/voip-readme.txt

	if ! use dedicated ; then
		newgamesbin engine/build/$(usex debug "debug" "release")-linux-${myarch}/turtlearena.${myarch} turtlearena
		newicon -s scalable engine/misc/quake3-tango.svg ${PN}.svg
		newicon -s 256 engine/misc/quake3-tango.png ${PN}.png
		make_desktop_entry ${PN}
	fi

	if use dedicated || use server ; then
		newgamesbin engine/build/$(usex debug "debug" "release")-linux-${myarch}/turtlearena-server.${myarch} turtlearena-server
	fi

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r "${WORKDIR}"/${MY_P}-0/base

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use dedicated || gnome2_icon_cache_update
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
