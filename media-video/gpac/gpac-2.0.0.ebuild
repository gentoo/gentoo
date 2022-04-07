# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/gpac/gpac"
else
	SRC_URI="https://github.com/gpac/gpac/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
fi

inherit flag-o-matic toolchain-funcs ${SCM} xdg

DESCRIPTION="Implementation of the MPEG-4 Systems standard developed from scratch in ANSI C"
HOMEPAGE="https://gpac.wp.imt.fr/"

LICENSE="GPL-2"
# subslot == libgpac major
SLOT="0/11"
IUSE="a52 aac alsa cpu_flags_x86_sse2 debug dvb ffmpeg ipv6 jack jpeg jpeg2k mad opengl oss png
	pulseaudio sdl ssl static-libs theora truetype vorbis xml xvid X"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	media-libs/libogg
	sys-libs/zlib
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:0= )
	jack? ( virtual/jack )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:2 )
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
		dev-libs/openssl:0=
	)
	vorbis? ( media-libs/libvorbis )
	X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXv
		x11-libs/libXext
	)
	xml? ( dev-libs/libxml2:2= )
	xvid? ( media-libs/xvid )
"
DEPEND="
	${RDEPEND}
	dvb? ( sys-kernel/linux-headers )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-configure.patch"
	"${FILESDIR}/${PN}-1.0.0-zlib-compile.patch"
)

DOCS=(
	share/doc/CODING_STYLE
	share/doc/GPAC\ UPnP.doc
	share/doc/ISO\ 639-2\ codes.txt
	share/doc/SceneGenerators
	share/doc/ipmpx_syntax.bt
	Changelog
	README.md
)

HTML_DOCS="share/doc/*.html"

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
		--cc="$(tc-getCC)"
		--libdir="$(get_libdir)"
		--verbose
		--enable-pic
		--enable-svg
		--disable-amr
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

	if use amd64 || use x86 ; then
		# Don't pass -mno-sse2 on non amd64/x86
		myeconfargs+=(
			--extra-cflags="${CFLAGS} $(usex cpu_flags_x86_sse2 '-msse2' '-mno-sse2')"
		)
	else
		myeconfargs+=(
			--extra-cflags="${CFLAGS}"
		)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	einstalldocs
	emake STRIP="true" DESTDIR="${ED}" install
	emake STRIP="true" DESTDIR="${ED}" install-lib
}
