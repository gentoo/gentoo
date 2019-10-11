# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/gpac/gpac"
else
	SRC_URI="https://github.com/gpac/gpac/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
fi

inherit flag-o-matic toolchain-funcs ${SCM}

DESCRIPTION="Implementation of the MPEG-4 Systems standard developed from scratch in ANSI C"
HOMEPAGE="https://gpac.wp.imt.fr/"

LICENSE="GPL-2"
# subslot == libgpac major
SLOT="0/7"
IUSE="a52 aac alsa debug dvb ffmpeg ipv6 jack jpeg jpeg2k libav libressl mad opengl oss png
	pulseaudio sdl ssl static-libs theora truetype vorbis xml xvid X"

RDEPEND="
	media-libs/libogg
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	jack? ( virtual/jack )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:0 )
	mad? ( media-libs/libmad )
	opengl? (
		media-libs/freeglut
		virtual/glu
		virtual/opengl
	)
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	theora? ( media-libs/libtheora )
	truetype? ( media-libs/freetype:2 )
	sdl? ( media-libs/libsdl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	vorbis? ( media-libs/libvorbis )
	X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXv
		x11-libs/libXext
	)
	xml? ( dev-libs/libxml2:2 )
	xvid? ( media-libs/xvid )
"
# disabled upstream, see applications/Makefile
# wxwidgets? ( =x11-libs/wxGTK-2.8* )
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dvb? ( sys-kernel/linux-headers )
"

# DOCS="AUTHORS BUGS Changelog README.md TODO doc/CODING_STYLE doc/*.doc doc/*.bt doc/SceneGenerators doc/ipmpx_syntax.bt doc/*.txt"
PATCHES=(
	"${FILESDIR}/${PN}-0.7.1-configure.patch"
	"${FILESDIR}/ffmpeg4.patch"
	"${FILESDIR}/${PN}-freetype.patch"
	"${FILESDIR}/${P}-openssl-1.1.patch"
)

DOCS=(
	doc/CODING_STYLE
	doc/GPAC\ UPnP.doc
	doc/ISO\ 639-2\ codes.txt
	doc/SceneGenerators
	doc/ipmpx_syntax.bt
	Changelog
	AUTHORS
	BUGS
	README.md
	TODO
)
HTML_DOCS="doc/*.html"

my_use() {
	local flag="$1" pflag="${2:-$1}"
	if use ${flag}; then
		echo "--use-${pflag}=system"
	else
		echo "--use-${pflag}=no"
	fi
}

src_prepare() {
	default
	sed -i -e "s:\(--disable-.*\)=\*):\1):" configure || die
}

src_configure() {
	tc-export CC CXX AR RANLIB

	local myeconfargs=(
		--extra-cflags="${CFLAGS}"
		--cc="$(tc-getCC)"
		--libdir="/$(get_libdir)"
		--verbose
		--enable-pic
		--enable-svg
		--disable-amr
		--disable-wx
		--use-js=no
		--use-ogg=system
		$(use_enable alsa)
		$(use_enable debug)
		$(use_enable dvb dvb4linux)
		$(use_enable ipv6)
		$(use_enable jack jack yes)
		$(use_enable opengl 3d)
		$(use_enable oss oss-audio)
		$(use_enable pulseaudio pulseaudio yes)
		$(use_enable sdl)
		$(use_enable ssl)
		$(use_enable static-libs static-lib)
		$(use_enable X x11)
		$(use_enable X x11-shm)
		$(use_enable X x11-xv)
		$(my_use a52)
		$(my_use aac faad)
		$(my_use dvb dvbx)
		$(my_use ffmpeg)
		$(my_use jpeg)
		$(my_use jpeg2k openjpeg)
		$(my_use mad)
		$(my_use png)
		$(my_use theora)
		$(my_use truetype ft)
		$(my_use vorbis)
		$(my_use xvid)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	einstalldocs
	emake STRIP="true" DESTDIR="${D}" install
	emake STRIP="true" DESTDIR="${D}" install-lib
}
