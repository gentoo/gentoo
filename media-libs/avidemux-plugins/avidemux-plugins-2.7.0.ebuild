# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/mean00/avidemux2.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}
	inherit git-r3
else
	MY_PN="${PN/-plugins/}"
	MY_P="${MY_PN}_${PV}"
	SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-single-r1

DESCRIPTION="Plugins for the video editor media-video/avidemux"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
SLOT="2.7"
IUSE="a52 aac aften alsa amr dcaenc debug dts fdk fontconfig fribidi jack lame libsamplerate cpu_flags_x86_mmx nvenc opengl opus oss pulseaudio qt5 truetype twolame vdpau vorbis vpx x264 x265 xv xvid"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	~media-libs/avidemux-core-${PV}:${SLOT}[vdpau?]
	~media-video/avidemux-${PV}:${SLOT}[opengl?,qt5?]
	>=dev-lang/spidermonkey-1.5-r2:0=
	dev-libs/libxml2:2
	media-libs/a52dec:0
	media-libs/libass:0=
	media-libs/libmad:0
	media-libs/libmp4v2:0
	media-libs/libpng:0=
	virtual/libiconv:0
	aac? (
		>=media-libs/faac-1.29.9.2:0
		media-libs/faad2:0
	)
	aften? ( media-libs/aften:0 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2:0 )
	amr? ( media-libs/opencore-amr:0 )
	dcaenc? ( media-sound/dcaenc:0 )
	dts? ( media-libs/libdca:0 )
	fdk? ( media-libs/fdk-aac:0= )
	fontconfig? ( media-libs/fontconfig:1.0 )
	fribidi? ( dev-libs/fribidi:0 )
	jack? (
		media-sound/jack-audio-connection-kit:0
		libsamplerate? ( media-libs/libsamplerate:0 )
	)
	lame? ( media-sound/lame:0 )
	nvenc? ( amd64? ( media-video/nvidia_video_sdk:0 ) )
	opus? ( media-libs/opus:0 )
	pulseaudio? ( media-sound/pulseaudio:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	truetype? ( media-libs/freetype:2 )
	twolame? ( media-sound/twolame:0 )
	vorbis? ( media-libs/libvorbis:0 )
	vpx? ( media-libs/libvpx:0= )
	x264? ( media-libs/x264:0= )
	x265? ( media-libs/x265:0= )
	xv? (
		x11-libs/libX11:0
		x11-libs/libXext:0
		x11-libs/libXv:0
	)
	xvid? ( media-libs/xvid:0 )
"
DEPEND="${COMMON_DEPEND}
	oss? ( virtual/os-headers:0 )
"
RDEPEND="${COMMON_DEPEND}
	!<media-libs/avidemux-plugins-${PV}
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.20-optional-pulse.patch
	"${FILESDIR}"/${P}-qt-5.11.patch
)

src_prepare() {
	default

	# Don't reapply PATCHES during cmake-utils_src_prepare
	unset PATCHES

	processes="buildPluginsCommon:avidemux_plugins
		buildPluginsCLI:avidemux_plugins"
	use qt5 && processes+=" buildPluginsQt4:avidemux_plugins"

	for process in ${processes} ; do
		CMAKE_USE_DIR="${S}"/${process#*:} cmake-utils_src_prepare
	done
}

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

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

		if use qt5 ; then
			mycmakeargs+=( -DENABLE_QT5=True )
		fi

		if use debug ; then
			mycmakeargs+=( -DVERBOSE=1 -DADM_DEBUG=1 )
		fi

		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${build}" cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		local build="${WORKDIR}/${P}_build/${process%%:*}"
		BUILD_DIR="${build}" cmake-utils_src_compile
	done
}

src_install() {
	for process in ${processes} ; do
		# cmake-utils_src_install doesn't respect BUILD_DIR
		# and there sometimes is a preinstall phase present.
		pushd "${WORKDIR}/${P}_build/${process%%:*}" > /dev/null || die
			grep '^preinstall/fast' Makefile && emake DESTDIR="${D}" preinstall/fast
			grep '^install/fast' Makefile && emake DESTDIR="${D}" install/fast
		popd > /dev/null || die
	done
}
