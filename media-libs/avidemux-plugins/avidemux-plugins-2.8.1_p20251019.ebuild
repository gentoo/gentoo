# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
# skip warning for ADM_demuxers/NativeAvisynth/CMakeLists.txt, unused (win)
CMAKE_QA_COMPAT_SKIP=1

inherit cmake flag-o-matic

MY_COMMIT="376c1469eebedcc724dbbcc0d45030f32c9d13f5"
DESCRIPTION="Plugins for Avidemux video editor"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="https://github.com/mean00/avidemux2/archive/${MY_COMMIT}.tar.gz -> avidemux-${PV}.tar.gz"
S="${WORKDIR}/avidemux2-${MY_COMMIT}"
CMAKE_USE_DIR="${S}/avidemux_plugins"

# Multiple licenses because of all the bundled stuff.
# See License.txt.
LICENSE="GPL-2 MIT PSF-2 LGPL-2 OFL-1.1"
SLOT="2.7"
KEYWORDS="~amd64 ~x86"
IUSE="aac aften alsa amr dcaenc dts fdk gui jack lame libaom libsamplerate nvenc opengl opus oss pulseaudio twolame vaapi vdpau vorbis vpx x264 x265 xvid"

COMMON_DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nvenc=,vaapi=,vdpau=]
	~media-video/avidemux-${PV}:${SLOT}[opengl?,gui?]
	dev-libs/fribidi
	media-libs/a52dec
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/libass:=
	media-libs/libmad
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
	jack? (
		virtual/jack
		libsamplerate? ( media-libs/libsamplerate )
	)
	lame? ( media-sound/lame )
	libaom? ( media-libs/libaom:= )
	nvenc? ( media-libs/nv-codec-headers )
	opengl? ( media-libs/libglvnd )
	opus? ( media-libs/opus )
	pulseaudio? ( media-libs/libpulse )
	gui? ( dev-qt/qtbase:6[gui,opengl,widgets] )
	twolame? ( media-sound/twolame )
	vaapi? ( media-libs/libva:= )
	vorbis? ( media-libs/libvorbis )
	vpx? ( media-libs/libvpx:0= )
	x264? ( media-libs/x264:0= )
	x265? ( media-libs/x265:0= )
	xvid? ( media-libs/xvid )
"
DEPEND="
	${COMMON_DEPEND}
	oss? ( virtual/os-headers )
"
RDEPEND="
	${COMMON_DEPEND}
	!<media-libs/avidemux-plugins-${PV}
"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.1_p20251019-optional-pulse.patch"
	"${FILESDIR}/${PN}-2.8.1_p20251019-optional-libsamplerate.patch"
	"${FILESDIR}/${PN}-2.8.1_p20251019-include.patch"
)

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/859829
	#
	# Upstream has abandoned sourceforge for github. And doesn't enable github issues.
	# Message received, no bug reported.
	filter-lto

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	PLUGINDIRS=(
		buildPluginsCommon
		buildPluginsCli
		$(usev gui buildPluginsQt4)
	)

	# checked by Common/Cli/Qt4
	local all_mycmakeargs=(
		-DVERBOSE=ON
		-DX264="$(usex x264)"
		-DX265="$(usex x265)"
	)

	# buildPluginsCommon
	local common_mycmakeargs=(
		-DPLUGIN_UI=COMMON
		"${all_mycmakeargs[@]}"
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DFAAC="$(usex aac)"
		-DFAAD="$(usex aac)"
		-DAFTEN="$(usex aften)"
		-DALSA="$(usex alsa)"
		-DOPENCORE_AMRNB="$(usex amr)"
		-DOPENCORE_AMRWB="$(usex amr)"
		-DDCAENC="$(usex dcaenc)"
		-DLIBDCA="$(usex dts)"
		-DFDK_AAC="$(usex fdk)"
		-DJACK="$(usex jack)"
		$(usev jack -DSRC=$(usex libsamplerate))
		-DLAME="$(usex lame)"
		-DAOM="$(usex libaom)"
		-DOPUS="$(usex opus)"
		-DOPUS_ENCODER="$(usex opus)"
		-DOSS="$(usex oss)"
		-DPULSEAUDIO="$(usex pulseaudio)"
		-DTWOLAME="$(usex twolame)"
		-DLIBVORBIS="$(usex vorbis)"
		-DVORBIS="$(usex vorbis)"
		-DVPXENC="$(usex vpx)"
		-DXVID="$(usex xvid)"
		-DUSE_EXTERNAL_LIBA52=yes
		-DUSE_EXTERNAL_LIBMAD=yes
	)

	# buildPluginsCli
	local cli_mycmakeargs=(
		-DPLUGIN_UI=CLI
		"${all_mycmakeargs[@]}"
	)

	# buildPluginsQt4
	local gui_mycmakeargs=(
		-DPLUGIN_UI=QT4
		"${all_mycmakeargs[@]}"
		-DENABLE_QT4=OFF
		-DENABLE_QT5=OFF
		-DENABLE_QT6=ON
		-DOPENGL="$(usex opengl)"
	)

	local plugin
	local mycmakeargs
	for plugin in "${PLUGINDIRS[@]}" ; do
		case "${plugin}" in
			"buildPluginsCommon")
				mycmakeargs=( "${common_mycmakeargs[@]}" ) ;;
			"buildPluginsCli")
				mycmakeargs=( "${cli_mycmakeargs[@]}" ) ;;
			"buildPluginsQt4")
				mycmakeargs=( "${gui_mycmakeargs[@]}" ) ;;
			*)
				die "plugin not available" ;;
		esac
		BUILD_DIR="${WORKDIR}/${P}_build/${plugin}" cmake_src_configure
	done
}

multi_plugins() {
	local plugin
	for plugin in "${PLUGINDIRS[@]}" ; do
		BUILD_DIR="${WORKDIR}/${P}_build/${plugin}" "${@}"
	done
}

src_compile() {
	multi_plugins cmake_src_compile
}

src_install() {
	multi_plugins cmake_src_install
}
