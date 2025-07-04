# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="A turtle featuring free and open source third-person action game (ioq3 engine)"
HOMEPAGE="https://clover.moe/turtlearena/"
SRC_URI="
	https://turtlearena.googlecode.com/files/${P}-0-src.tar.bz2
	https://turtlearena.googlecode.com/files/${P}-0.zip"
S="${WORKDIR}/${P}-0-src"

LICENSE="GPL-2+ CC-BY-SA-3.0 mplus-fonts lcc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+curl debug dedicated mumble openal server theora voice vorbis"

RDEPEND="
	sys-libs/zlib:=[minizip]
	!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl[X,joystick,opengl,sound,video]
		virtual/jpeg
		virtual/opengl
		curl? ( net-misc/curl )
		openal? ( media-libs/openal )
		theora? ( media-libs/libtheora:= )
		voice? (
			media-libs/speex
			mumble? ( net-voip/mumble )
		)
		vorbis? ( media-libs/libvorbis )
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-freetype.patch
)

src_prepare() {
	default

	sed -e 's|JPEG_LIB_VERSION < 80|JPEG_LIB_VERSION < 62|' \
		-i engine/code/renderer/tr_image_jpg.c || die #479822

	rm -r engine/code/{AL,libcurl,libogg,libspeex,libtheora,libvorbis,SDL12,zlib} \
		engine/code/freetype* engine/code/jpeg-* \
		engine/code/qcommon/unzip.{c,h} || die
}

src_compile() {
	tc-export CC

	MY_ARCH=$(usex amd64 x86_64 x86)
	MY_RELEASE=$(usex debug debug release)

	local emakeargs=(
		ARCH=${MY_ARCH}
		BUILD_CLIENT=$(usex dedicated 0 1)
		BUILD_SERVER=$(usex dedicated 1 $(usex server 1 0))
		BUILD_GAME_QVM=0
		BUILD_GAME_SO=0
		CROSS_COMPILING=0
		DEBUG_CFLAGS=
		DEFAULT_BASEDIR="${EPREFIX}"/usr/share/${PN}
		GENERATE_DEPENDENCIES=0
		OPTIMIZE=
		OPTIMIZEVM=
		Q=
		USE_CODEC_THEORA=$(usex theora 1 0)
		USE_CODEC_VORBIS=$(usex vorbis 1 0)
		USE_CURL=$(usex curl 1 0)
		USE_CURL_DLOPEN=0
		USE_INTERNAL_FREETYPE=0
		USE_INTERNAL_JPEG=0
		USE_INTERNAL_OGG=0
		USE_INTERNAL_SPEEX=0
		USE_INTERNAL_VORBIS=0
		USE_INTERNAL_ZLIB=0
		USE_LOCAL_HEADERS=0
		USE_MUMBLE=$(usex mumble 1 0)
		USE_OPENAL=$(usex openal 1 0)
		USE_OPENAL_DLOPEN=0
		USE_VOIP=$(usex voice 1 0)
	)

	emake -C engine "${emakeargs[@]}" ${MY_RELEASE}
}

src_install() {
	if ! use dedicated; then
		newbin engine/build/${MY_RELEASE}-linux-${MY_ARCH}/turtlearena.${MY_ARCH} turtlearena

		use voice && dodoc engine/voip-readme.txt

		newicon engine/misc/quake3-tango.svg ${PN}.svg
		make_desktop_entry ${PN} "Turtle Arena"
	fi

	if use dedicated || use server; then
		newbin engine/build/${MY_RELEASE}-linux-${MY_ARCH}/turtlearena-server.${MY_ARCH} turtlearena-server
	fi

	insinto /usr/share/${PN}
	doins -r ../${P}-0/base

	dodoc engine/{ChangeLog,BUGS,TODO}
}
