# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.5.6-r2.ebuild,v 1.5 2013/07/18 20:58:17 creffett Exp $

EAPI="5"

inherit cmake-utils eutils flag-o-matic

MY_P=${PN}_${PV}

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE="aac aften alsa amr gtk jack +mp3 nls opengl oss pulseaudio
	qt4 sdl +truetype vorbis vpx +x264 +xv +xvid"

RDEPEND="
	dev-libs/libxml2
	sys-libs/zlib
	aac? (
		media-libs/faac
		media-libs/faad2
	)
	aften? ( media-libs/aften[cxx] )
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	gtk? ( x11-libs/gtk+:2 )
	jack? (
		media-libs/libsamplerate
		media-sound/jack-audio-connection-kit
	)
	mp3? ( media-sound/lame )
	pulseaudio? ( media-sound/pulseaudio )
	qt4? (
		>=dev-qt/qtgui-4.6:4
		opengl? (
			virtual/opengl
			>=dev-qt/qtopengl-4.6:4
		)
	)
	sdl? ( media-libs/libsdl )
	truetype? (
		media-libs/freetype:2
		media-libs/fontconfig
	)
	vorbis? ( media-libs/libvorbis )
	vpx? ( media-libs/libvpx )
	x264? ( media-libs/x264:= )
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)
	xvid? ( media-libs/xvid )
"
DEPEND="${RDEPEND}
	dev-lang/yasm
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

AVIDEMUX_LANGS="bg ca cs de el es fr it ja pt_BR ru sr sr@latin tr zh_TW"
for lang in ${AVIDEMUX_LANGS}; do
	IUSE+=" linguas_${lang}"
done
unset lang

S=${WORKDIR}/${MY_P}
BUILD_S=${WORKDIR}/${P}_build

DOCS=( AUTHORS )
PATCHES=(
	"${FILESDIR}/${PN}-2.5.4-build-plugins-fix.patch"
	"${FILESDIR}/${P}-ffmpeg-symbol-visibility.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	local lingua= po_files= qt_ts_files= avidemux_ts_files=
	for lingua in ${LINGUAS}; do
		if has ${lingua} ${AVIDEMUX_LANGS}; then
			if [[ -e ${S}/po/${lingua}.po ]]; then
				po_files+=" \${po_subdir}/${lingua}.po"
			fi
			if [[ -e ${S}/po/qt_${lingua}.ts ]]; then
				qt_ts_files+=" \${ts_subdir}/qt_${lingua}.ts"
			fi
			if [[ -e ${S}/po/${PN}_${lingua}.ts ]]; then
				avidemux_ts_files+=" \${ts_subdir}/${PN}_${lingua}.ts"
			fi
		fi
	done

	sed -i -e "s!FILE(GLOB po_files .*)!SET(po_files ${po_files})!" \
		"${S}/cmake/Po.cmake" || die "sed failed"
	sed -i -e "s!FILE(GLOB.*qt.*)!SET(ts_files ${qt_ts_files})!" \
	    -e "s!FILE(GLOB.*avidemux.*)!SET(ts_files ${avidemux_ts_files})!" \
		"${S}/cmake/Ts.cmake" || die "sed failed"

	# fix major issues in desktop files wrt bugs #291453, #316599, #430500
	sed -i -re '/^(Exec|Path)/ s:\[\$e\]::' avidemux2-gtk.desktop || die
	sed -i -re '/^Exec/ s:(avidemux2_)gtk:\1qt4:' avidemux2.desktop || die

	# don't install Windows-only files
	sed -i -e '/addons\/avsfilter/d' CMakeLists.txt || die
}

src_configure() {
	# add lax vector typing for PowerPC
	if use ppc || use ppc64; then
		append-cflags -flax-vector-conversions
	fi
	# bug 432322
	use x86 && replace-flags -O0 -O1

	local mycmakeargs=(
		-DAVIDEMUX_SOURCE_DIR="${S}"
		-DAVIDEMUX_INSTALL_PREFIX="${BUILD_S}"
		-DAVIDEMUX_CORECONFIG_DIR="${BUILD_S}/config"
		-DARTS=OFF
		-DESD=OFF
		$(cmake-utils_use aac FAAC)
		$(cmake-utils_use aac FAAD)
		$(cmake-utils_use aften)
		$(cmake-utils_use alsa)
		$(cmake-utils_use amr OPENCORE_AMRNB)
		$(cmake-utils_use amr OPENCORE_AMRWB)
		$(cmake-utils_use gtk)
		$(cmake-utils_use jack)
		$(cmake-utils_use mp3 LAME)
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use_use opengl)
		$(cmake-utils_use oss)
		$(cmake-utils_use pulseaudio PULSEAUDIOSIMPLE)
		$(cmake-utils_use qt4)
		$(cmake-utils_use sdl)
		$(cmake-utils_use truetype FREETYPE2)
		$(cmake-utils_use truetype FONTCONFIG)
		$(cmake-utils_use vorbis)
		$(cmake-utils_use vorbis LIBVORBIS)
		$(cmake-utils_use vpx VPXDEC)
		$(cmake-utils_use x264)
		$(cmake-utils_use xv XVIDEO)
		$(cmake-utils_use xvid)
	)
	cmake-utils_src_configure
}

src_compile() {
	# first build the application
	cmake-utils_src_compile -j1

	# and then go on with plugins
	emake -C "${CMAKE_BUILD_DIR}/plugins"
}

src_install() {
	# install the application
	cmake-utils_src_install

	# install plugins
	emake -C "${CMAKE_BUILD_DIR}/plugins" DESTDIR="${D}" install

	newicon ${PN}_icon.png ${PN}.png
	use gtk && domenu avidemux2-gtk.desktop
	use qt4 && domenu avidemux2.desktop
}
