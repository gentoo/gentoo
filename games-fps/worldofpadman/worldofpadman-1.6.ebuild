# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="A cartoon style multiplayer first-person shooter"
HOMEPAGE="http://worldofpadman.net/"
SRC_URI="mirror://sourceforge/${PN}/wop-1.5-unified.zip
	mirror://sourceforge/${PN}/wop-1.5.x-to-1.6-patch-unified.zip"

LICENSE="GPL-2 worldofpadman"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+curl dedicated maps +openal +theora +vorbis"

RDEPEND="sys-libs/zlib
	!dedicated? (
		|| (
			(
				>=media-libs/speex-1.2.0
				media-libs/speexdsp
			)
			<media-libs/speex-1.2.0
		)
		virtual/jpeg:0
		media-libs/libsdl[opengl,video,X]
		virtual/opengl
		virtual/glu
		openal? ( media-libs/openal )
		curl? ( net-misc/curl )
		vorbis? ( media-libs/libvorbis )
		theora? (
			media-libs/libtheora
			media-libs/libogg
		)
	)"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}_svn2178-src

src_unpack() {
	unpack ${A}
	unzip XTRAS/"editing files"/${P}-src.zip
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e 's:JPEG_LIB_VERSION < 80:JPEG_LIB_VERSION < 62:' \
		code/renderer/tr_image_jpg.c || die #479652
}

src_compile() {
	local arch

	if use amd64 ; then
		arch=x86_64
	elif use x86 ; then
		arch=i386
	fi

	emake \
		V=1 \
		ARCH=${arch} \
		BUILD_CLIENT=$(use dedicated && echo 0) \
		DEFAULT_BASEDIR="${GAMES_DATADIR}"/${PN} \
		OPTIMIZE= \
		USE_CURL=$(usex curl 1 0) \
		USE_CURL_DLOPEN=0 \
		USE_OPENAL=$(usex openal 1 0) \
		USE_OPENAL_DLOPEN=0 \
		USE_CODEC_VORBIS=$(usex vorbis 1 0) \
		USE_CIN_THEORA=$(usex theora 1 0) \
		USE_RENDERER_DLOPEN=0 \
		USE_INTERNAL_ZLIB=0 \
		USE_INTERNAL_JPEG=0 \
		USE_INTERNAL_SPEEX=0
}

src_install() {
	newgamesbin build/release-*/wopded.* ${PN}-ded
	if ! use dedicated ; then
		newgamesbin build/release-*/wop.* ${PN}
		newicon misc/quake3.png ${PN}.png
		make_desktop_entry ${PN} "World of Padman"
	fi
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ../wop

	dodoc id-readme.txt \
		IOQ3-README \
		voip-readme.txt \
		../XTRAS/changelog.txt \
		../XTRAS/sounds_readme.txt
	dohtml -r ../XTRAS/readme{,.html}
	prepgamesdirs
}
