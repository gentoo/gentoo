# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake python-single-r1

DESCRIPTION="Plugins for the video editor media-video/avidemux"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="https://github.com/mean00/avidemux2/archive/${PV}.tar.gz -> avidemux-${PV}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.7"
IUSE="a52 aac aften alsa amr dcaenc debug dts fdk fontconfig fribidi jack lame libsamplerate cpu_flags_x86_mmx nvenc opengl opus oss pulseaudio qt5 truetype twolame vdpau vorbis vpx x264 x265 xv xvid"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	~media-libs/avidemux-core-${PV}:${SLOT}[vdpau?]
	~media-video/avidemux-${PV}:${SLOT}[opengl?,qt5?]
	dev-lang/spidermonkey:0=
	dev-libs/libxml2:2
	media-libs/a52dec
	media-libs/libass:0=
	media-libs/libmad
	media-libs/libmp4v2
	media-libs/libpng:0=
	virtual/libiconv
	aac? (
		media-libs/faac
		media-libs/faad2
	)
	aften? ( media-libs/aften )
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	dcaenc? ( media-sound/dcaenc )
	dts? ( media-libs/libdca )
	fdk? ( media-libs/fdk-aac:0= )
	fontconfig? ( media-libs/fontconfig:1.0 )
	fribidi? ( dev-libs/fribidi )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	lame? ( media-sound/lame )
	nvenc? ( amd64? ( media-video/nvidia_video_sdk ) )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	truetype? ( media-libs/freetype:2 )
	twolame? ( media-sound/twolame )
	vorbis? ( media-libs/libvorbis )
	vpx? ( media-libs/libvpx:0= )
	x264? ( media-libs/x264:0= )
	x265? ( media-libs/x265:0= )
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)
	xvid? ( media-libs/xvid )
"
DEPEND="${COMMON_DEPEND}
	oss? ( virtual/os-headers )
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/avidemux-plugins-${PV}
"

S="${WORKDIR}/avidemux2-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-2.6.20-optional-pulse.patch )

src_prepare() {
	default

	# Don't reapply PATCHES during cmake_src_prepare
	unset PATCHES

	processes="buildPluginsCommon:avidemux_plugins
		buildPluginsCLI:avidemux_plugins"
	use qt5 && processes+=" buildPluginsQt4:avidemux_plugins"

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake_src_prepare
	done
}

src_configure() {
	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"

		local mycmakeargs=(
			-DAVIDEMUX_SOURCE_DIR='${S}'
			-DPLUGIN_UI=$(echo ${build/buildPlugins/} | tr '[:lower:]' '[:upper:]')
			-DFAAC="$(usex aac)"
			-DFAAD="$(usex aac)"
			-DALSA="$(usex alsa)"
			-DAFTEN="$(usex aften)"
			-DDCAENC="$(usex dcaenc)"
			-DFDK_AAC="$(usex fdk)"
			-DOPENCORE_AMRWB="$(usex amr)"
			-DOPENCORE_AMRNB="$(usex amr)"
			-DLIBDCA="$(usex dts)"
			-DFONTCONFIG="$(usex fontconfig)"
			-DJACK="$(usex jack)"
			-DLAME="$(usex lame)"
			-DNVENC="$(usex nvenc)"
			-DOPENGL="$(usex opengl)"
			-DOPUS="$(usex opus)"
			-DOSS="$(usex oss)"
			-DPULSEAUDIOSIMPLE="$(usex pulseaudio)"
			-DQT4=OFF
			-DFREETYPE2="$(usex truetype)"
			-DTWOLAME="$(usex twolame)"
			-DX264="$(usex x264)"
			-DX265="$(usex x265)"
			-DXVIDEO="$(usex xv)"
			-DXVID="$(usex xvid)"
			-DVDPAU="$(usex vdpau)"
			-DVORBIS="$(usex vorbis)"
			-DLIBVORBIS="$(usex vorbis)"
			-DVPXDEC="$(usex vpx)"
			-DUSE_EXTERNAL_LIBA52=yes
			-DUSE_EXTERNAL_LIBASS=yes
			-DUSE_EXTERNAL_LIBMAD=yes
			-DUSE_EXTERNAL_LIBMP4V2=yes
		)

		use qt5 && mycmakeargs+=( -DENABLE_QT5=True )
		use debug && mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )

		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${build}" cmake_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake_src_compile
	done
}

src_install() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake_src_install
	done
}
